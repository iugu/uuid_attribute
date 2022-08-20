# frozen_string_literal: true

require "rails/railtie"

module UuidAttribute
  # Rails Initializer
  class Railtie < Rails::Railtie
    railtie_name :uuid_attribute_railtie
    config.eager_load_namespaces << ::UuidAttribute

    class << self
      def binary16_structure?(field_info)
        field_info.type == :binary && field_info.limit == 16
      end

      def binary16?(klass, field)
        field_info = klass.attribute_types[field]
        binary16_structure?(field_info) && klass.method_defined?("#{field}?")
      end

      def valid_default_rails_ids?(att)
        att.eql?("id") || att.end_with?("_id")
      end
    end

=begin
all_models = ObjectSpace.each_object(Class).select { |c| c < ApplicationRecord}.select(&:name)
all_models.each do |model|
  puts model
  model.attribute_names.each do |att|
    next unless valid_default_rails_ids?(att) && binary16?(att)

    default = nil
    default = -> { SecureRandom.uuid } if att.eql? "id"
    self.class.define_attribute att, ::UuidAttribute::UUID.new, default: default
  end
end
=end

    config.after_initialize do
      ActiveRecord::Type.register(:uuid, ::UuidAttribute::UUID)

      if UuidAttribute.auto_detect_binary_ids
        models = []
        Dir["#{Rails.root}/app/models/*"].each do |file|
          model = File.basename(file, ".*").classify
          models << model unless models.include?(model)
        end

        models -= %w[ActiveRecord Concern]

        models.each do |model|
          model = model.constantize
          model.attribute_names.each do |att|
            next unless valid_default_rails_ids?(att) && binary16?(model, att)

            default = nil
            default = -> { SecureRandom.uuid } if att.eql? "id"
            model.define_attribute att, ::UuidAttribute::UUID.new, default: default
          end
        end
      end

      # ActiveRecord::Base.include ::UuidAttribute::ActiveModel if defined? ActiveRecord::Base

      if UuidAttribute.default_primary_id
        # Configure UUID as Default Primary Key
        Rails.application.config.generators do |g|
          g.orm :active_record, primary_key_type: "binary, limit: 16"
        end
      end
    end
  end
end
