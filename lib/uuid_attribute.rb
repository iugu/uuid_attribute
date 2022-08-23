# frozen_string_literal: true

require "active_model"
require "active_model/type"
require "rails"
require_relative "uuid_attribute/version"
require_relative "uuid_attribute/uuid"
require_relative "uuid_attribute/utils"

# UUID::Attribute is a module that provides a UUID attribute for ActiveRecord
module UuidAttribute
  extend ActiveSupport::Autoload

  eager_autoload do
    UUID
  end

  class Error < StandardError; end

  ## CONFIGURATION OPTIONS

  mattr_accessor :auto_detect_binary_ids
  self.auto_detect_binary_ids = true

  mattr_accessor :default_primary_id
  self.default_primary_id = true

  def self.setup
    yield self
  end
end

require_relative "uuid_attribute/railtie" if defined?(Rails)
