# frozen_string_literal: true

require "simplecov"
$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

SimpleCov.start "rails" do
  add_filter %r{^/test/}
  add_filter "lib/uuid_attribute/version"
end

require "minitest/autorun"
require "uuid_attribute"
