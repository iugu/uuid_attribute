# frozen_string_literal: true

require "rails/railtie"
require "active_record/associations/association_scope"
require "active_record/fixture_set/table_row"

module ActiveRecord
  module Associations
    class AssociationScope # :nodoc:
      def last_chain_scope(scope, reflection, owner)
        primary_key = reflection.join_primary_key
        foreign_key = reflection.join_foreign_key

        table = reflection.aliased_table

        prevalue = owner[foreign_key]
        if owner.class.attribute_types[foreign_key].class.name == "UuidAttribute::Type"
          prevalue = UuidAttribute::Utils.raw_bytes(UuidAttribute::Utils.normalize(UuidAttribute::Utils.parse(prevalue)))
        end

        value = transform_value(prevalue)
        scope = apply_scope(scope, table, primary_key, value)

        if reflection.type
          polymorphic_type = transform_value(owner.class.polymorphic_name)
          scope = apply_scope(scope, table, reflection.type, polymorphic_type)
        end

        scope
      end
    end
  end
end

module ActiveStorage
  class FixtureSet
    def self.blob(filename:, **attributes)
      generated_uuid = Digest::UUID.uuid_v5(Digest::UUID::OID_NAMESPACE, filename)
      raw_uuid = UuidAttribute::Utils.raw_bytes(
        UuidAttribute::Utils.normalize(UuidAttribute::Utils.parse(generated_uuid))
      )
      new.prepare Blob.new(filename: filename, id: raw_uuid, key: generated_uuid), **attributes
    end
  end
end

module ActiveRecord
  class FixtureSet
    class << self
      def identify(label, column_type = :integer)
        if column_type == :uuid
          generated_uuid = Digest::UUID.uuid_v5(Digest::UUID::OID_NAMESPACE, label.to_s)
          UuidAttribute::Utils.raw_bytes(UuidAttribute::Utils.normalize(UuidAttribute::Utils.parse(generated_uuid)))
        else
          Zlib.crc32(label.to_s) % MAX_ID
        end
      end
    end

    class TableRow
      private

      alias org_fill_row_model_attributes fill_row_model_attributes
      def fill_row_model_attributes
        org_fill_row_model_attributes
        return unless model_class

        resolve_string_uuids
      end

      def resolve_string_uuids
        @row.each do |key, value|
          next if model_class.to_s.include?("ActiveStorage") && key == "record_id"

          transform_uuid(key, value)
        end
      end

      def transform_uuid(key, value)
        if test_uuid36?(key, value)
          @row[key] = [value&.gsub("-", "")&.upcase].pack("H*")
        elsif test_uuid22?(key, value)
          @row[key] = [UuidAttribute::Utils.unshort(value)&.gsub("-", "")&.upcase].pack("H*")
        end
      end

      def test_uuid36?(key, value)
        (key == "id" || key.ends_with?("_id")) && value.instance_of?(String) && value.length == 36
      end

      def test_uuid22?(key, value)
        (key == "id" || key.ends_with?("_id")) && value.instance_of?(String) && value.length == 22
      end
    end
  end
end

module UuidAttribute
  # Rails Initializer
  class Railtie < Rails::Railtie
    railtie_name :uuid_attribute_railtie
    config.eager_load_namespaces << ::UuidAttribute

    class << self
      def binary_structure?(field_info)
        field_info.type == :binary
      end

      def binary?(klass, field)
        field_info = klass.attribute_types[field]
        binary_structure?(field_info)
        # && klass.method_defined?("#{field}?")
      end

      def valid_default_rails_ids?(att)
        att.eql?("id") || att.end_with?("_id")
      end

      def list_models
        models = []
        Dir["#{Rails.root}/app/models/*"].each do |file|
          model = File.basename(file, ".*").camelcase
          models << model unless models.include?(model)
        end

        models -= %w[ActiveRecord Concern]

        begin
          ActiveStorage::VariantRecord.new
          ActiveStorage::Attachment.new
          ActiveStorage::Blob.new
        rescue
        end

        models.each do |m|
          Object.const_get(m)
        rescue NameError
        end
        all_active_record_classes
      end

      def all_active_record_classes
        ObjectSpace.each_object(Class).select { |c| c < ActiveRecord::Base }.select(&:name)
      end

      def configure_binary_ids
        list_models.each do |model|
          model.attribute_names.each do |att|
            next unless valid_default_rails_ids?(att) && binary?(model, att)

            default = nil
            default = -> { SecureRandom.uuid } if att.eql? "id"
            model.attribute att, ::UuidAttribute::Type.new, default: default
          end
        end
      rescue ActiveRecord::NoDatabaseError
        false
      else
        true
      end
    end

    config.to_prepare do
      ActiveRecord::Type.register(:uuid, ::UuidAttribute::UUID)

      ::UuidAttribute::Railtie::configure_binary_ids if UuidAttribute.auto_detect_binary_ids

      if UuidAttribute.default_primary_id
        # Configure UUID as Default Primary Key
        Rails&.application&.config&.generators do |g|
          g.orm :active_record, primary_key_type: "binary, limit: 16"
        end
      end
    rescue ActiveRecord::StatementInvalid, ActiveRecord::DatabaseConnectionError
      Rails.logger.debug("Ignoring database on uuid init.")
    end
  end
end
