# frozen_string_literal: true

require "fileutils"
require "pathname"
# require "active_support/configuration_file"

module ARTest
  class << self
    def config
      @config ||= YAML.safe_load(File.read(config_file))
      # ActiveSupport::ConfigurationFile.parse(config_file)
    end

    private

    def config_file
      Pathname.new(ENV["ARCONFIG"] || "#{TEST_ROOT}/config/config.yml")
    end
  end
end
