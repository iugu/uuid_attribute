# frozen_string_literal: true

require "test_helper"

module UUID
  class TestAttribute < Minitest::Test
    def test_that_it_has_a_version_number
      refute_nil ::UUID::Attribute::VERSION
    end

    def test_it_does_something_useful
      assert false
    end
  end
end
