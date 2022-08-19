# frozen_string_literal: true

module UuidAttribute
  # ActiveModel modifications
  module ActiveModel
    extend ActiveSupport::Concern

=begin
    included do
      alias_method :initialize_without_uuid, :initialize
      alias_method :initialize, :uuid_initializer
    end

    def uuid_initializer(*args)
      auto_detect_uuids
      initialize_without_uuid(*args)
    end

    def binary16_structure?(field_info)
      field_info.type == :binary && field_info.limit == 16
    end

    def binary16?(field)
      field_info = self.class.attribute_types[field]
      binary16_structure?(field_info) && respond_to?("#{field}?")
    end

    def valid_default_rails_ids?(att)
      att.eql?("id") || att.end_with?("_id")
    end

    def auto_detect_uuids
      return unless UuidAttribute.auto_detect_binary_ids

      self.class.attribute_names.each do |att|
        next unless valid_default_rails_ids?(att) && binary16?(att)

        default = nil
        default = -> { SecureRandom.uuid } if att.eql? "id"
        self.class.define_attribute att, ::UuidAttribute::UUID.new, default: default
      end
    end
=end
  end
end
