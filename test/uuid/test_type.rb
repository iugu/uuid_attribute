# frozen_string_literal: true

require "test_helper"
require "active_record"

module UUID
  class TestType < Minitest::Test
    UNORMALIZED_UUID = "a0b1c2d3-e4f5-a6b7-c8d9-e0f1a2b3c4d5"
    NORMALIZED_UUID = "A0B1C2D3E4F5A6B7C8D9E0F1A2B3C4D5"
    BINARY_UUID = "\xA0\xB1\xC2\xD3\xE4\xF5\xA6\xB7\xC8\xD9\xE0\xF1\xA2\xB3\xC4\xD5"
    SHORTEN_UUID = "4tE0ZuelqYsF4p2FEnW2qb"

    def test_type
      assert_equal(::UuidAttribute::UUID.new.type, :uuid)
    end

    def test_deserialize
      assert_nil(::UuidAttribute::UUID.new.deserialize(nil))
      assert_equal(
        ::UuidAttribute::UUID.new.deserialize(UNORMALIZED_UUID),
        SHORTEN_UUID
      )
    end

    def test_serialize
      assert_nil(::UuidAttribute::UUID.new.serialize(nil))
      result = ::UuidAttribute::UUID.new.serialize(UNORMALIZED_UUID)
      assert_equal("ActiveModel::Type::Binary::Data", result.class.name)
      assert_equal(BINARY_UUID.bytes, result.to_s.bytes)
    end

    def test_cast
      assert_nil(::UuidAttribute::UUID.new.cast(nil))
      assert_equal(
        ::UuidAttribute::UUID.new.cast(UNORMALIZED_UUID),
        SHORTEN_UUID
      )
    end
  end
end
