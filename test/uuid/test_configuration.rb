# frozen_string_literal: true

require "test_helper"

module UUID
  class TestConfiguration < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::UuidAttribute::VERSION
    end

    def test_auto_detect_binary_ids
      ::UuidAttribute.setup do |config|
        config.auto_detect_binary_ids = false
      end
      refute ::UuidAttribute.auto_detect_binary_ids

      ::UuidAttribute.setup do |config|
        config.auto_detect_binary_ids = true
      end
      assert ::UuidAttribute.auto_detect_binary_ids
    end

    def test_default_primary_id
      ::UuidAttribute.setup do |config|
        config.default_primary_id = false
      end
      refute ::UuidAttribute.default_primary_id

      ::UuidAttribute.setup do |config|
        config.default_primary_id = true
      end
      assert ::UuidAttribute.default_primary_id
    end
  end
end
