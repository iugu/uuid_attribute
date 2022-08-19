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

      def binary16?(field)
        field_info = self.class.attribute_types[field]
        binary16_structure?(field_info) && respond_to?("#{field}?")
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
      # unless SimpleForm.configured?
      #  warn '[Simple Form] Simple Form is not configured in the application and will use the default values.' +
      #    ' Use `rails generate simple_form:install` to generate the Simple Form configuration.'
      # end

      ActiveRecord::Type.register(:uuid, ::UuidAttribute::UUID)

      ActiveRecord::Base.include ::UuidAttribute::ActiveModel if defined? ActiveRecord::Base

      if UuidAttribute.default_primary_id
        # Configure UUID as Default Primary Key
        Rails.application.config.generators do |g|
          g.orm :active_record, primary_key_type: "binary, limit: 16"
        end
      end
    end
  end
end
