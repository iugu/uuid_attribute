# frozen_string_literal: true

require "simplecov"
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

SimpleCov.start "rails" do
  add_filter %r{^/test/}
  add_filter "lib/uuid_attribute/version"
end

require "rails"
require "active_record"
require "minitest/autorun"

TEST_ROOT = __dir__
require "config/config"
puts "Testing with adapter #{ENV["TEST_ADAPTER"]} - Rails Version: #{Rails.version}"

# ActiveRecord.async_query_executor = :global_thread_pool if ActiveRecord.respond_to?(:async_query_executor)
ActiveRecord::Base.configurations = ARTest.config["connections"]
# ActiveRecord::Base.logger = Logger.new(STDOUT)

if Rails::VERSION::MAJOR >= 7 || (Rails::VERSION::MAJOR == 6 && Rails::VERSION::MINOR.positive?)
  DATABASE_CONFIG = ActiveRecord::DatabaseConfigurations::HashConfig.new(
    "test",
    "test",
    ARTest.config["connections"][ENV["TEST_ADAPTER"]]
  )
end
if Rails::VERSION::MAJOR == 6 && Rails::VERSION::MINOR.zero?
  DATABASE_CONFIG = ARTest.config["connections"][ENV["TEST_ADAPTER"]]
end
ActiveRecord::Tasks::DatabaseTasks.purge(DATABASE_CONFIG) unless ENV["TEST_ADAPTER"] != "sqlite"
ActiveRecord::Tasks::DatabaseTasks.load_schema(
  DATABASE_CONFIG,
  :ruby,
  "#{TEST_ROOT}/config/schema.rb"
)
ActiveRecord::Base.establish_connection DATABASE_CONFIG
# load_schema(db_config, format = ActiveRecord.schema_format, file = nil) # :no

require "uuid_attribute"
