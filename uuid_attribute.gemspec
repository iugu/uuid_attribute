# frozen_string_literal: true

require_relative "lib/uuid_attribute/version"

Gem::Specification.new do |spec|
  spec.name = "uuid_attribute"
  spec.version = UuidAttribute::VERSION.dup
  spec.authors = ["Patrick Negri"]
  spec.email = ["patrick@iugu.com"]
  spec.license = "MIT"

  spec.summary = "UUID attribute for ActiveRecord"
  spec.description = "UUID attribute for ActiveRecord"
  spec.homepage = "https://github.com/iugu/activerecord-uuid-attribute"
  spec.required_ruby_version = ">= 2.6.0"
  spec.metadata = {
    "homepage_uri"      => "https://github.com/iugu/activerecord-uuid-attribute",
    "documentation_uri" => "https://rubydoc.info/github/iugu/simple_form/activerecord-uuid-attribute",
    "changelog_uri"     => "https://github.com/iugu/activerecord-uuid-attribute/blob/main/CHANGELOG.md",
    "source_code_uri"   => "https://github.com/iugu/activerecord-uuid-attribute",
    "bug_tracker_uri"   => "https://github.com/iugu/activerecord-uuid-attribute/issues"
  }

  spec.files         = Dir["CHANGELOG.md", "LICENSE.md", "README.md", "lib/**/*"]
  spec.test_files    = Dir["test/**/*.rb"]
  spec.require_paths = ["lib"]

  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency("activemodel", ">= 5.2")
end
