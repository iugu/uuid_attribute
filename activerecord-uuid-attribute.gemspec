# frozen_string_literal: true

require_relative "lib/uuid/attribute/version"

Gem::Specification.new do |spec|
  spec.name = "activerecord-uuid-attribute"
  spec.version = UUID::Attribute::VERSION
  spec.authors = ["Patrick Negri"]
  spec.email = ["patrick@iugu.com"]
  spec.license     = "MIT"

  spec.summary = "Write a short summary, because RubyGems requires one."
  spec.description = "Another one"
  spec.homepage = "https://github.com/iugu/activerecord-uuid-attribute"
  spec.required_ruby_version = ">= 2.6.0"
  spec.metadata = {
    "homepage_uri"      => "https://github.com/iugu/activerecord-uuid-attribute",
    "documentation_uri" => "https://rubydoc.info/github/iugu/simple_form/activerecord-uuid-attribute",
    "changelog_uri"     => "https://github.com/iugu/activerecord-uuid-attribute/blob/main/CHANGELOG.md",
    "source_code_uri"   => "https://github.com/iugu/activerecord-uuid-attribute",
    "bug_tracker_uri"   => "https://github.com/iugu/activerecord-uuid-attribute/issues"
  }

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency "example-gem", "~> 1.0"
end
