# frozen_string_literal: true

require "test_helper"

module UUID
  class TestUtilities < Minitest::Test
    UNORMALIZED_UUID = "a0b1c2d3-e4f5-a6b7-c8d9-e0f1a2b3c4d5"
    NORMALIZED_UUID = "A0B1C2D3E4F5A6B7C8D9E0F1A2B3C4D5"
    BINARY_UUID = "\xA0\xB1\xC2\xD3\xE4\xF5\xA6\xB7\xC8\xD9\xE0\xF1\xA2\xB3\xC4\xD5"
    SHORTEN_UUID = "4tE0ZuelqYsF4p2FEnW2qb"

    def test_normalization
      result = ::UuidAttribute::Utils.normalize(UNORMALIZED_UUID)
      assert_equal(NORMALIZED_UUID, result)
    end

    def test_hex_from_binary
      result = ::UuidAttribute::Utils.hex_from_binary(BINARY_UUID)
      assert_equal(NORMALIZED_UUID, result)
    end

    def test_raw_bytes
      result = ::UuidAttribute::Utils.raw_bytes(NORMALIZED_UUID)
      assert_equal(BINARY_UUID.bytes, result.bytes)
    end

    def test_shorten
      result = ::UuidAttribute::Utils.shorten(UNORMALIZED_UUID)
      assert_equal(SHORTEN_UUID, result)
    end

    def test_unshorten
      result = ::UuidAttribute::Utils.unshort(SHORTEN_UUID)
      assert_equal(UNORMALIZED_UUID, result)
    end

    def test_short_and_unshort
      random_uuid = SecureRandom.uuid
      shorted_uuid = ::UuidAttribute::Utils.shorten(random_uuid)
      unshorted_uuid = ::UuidAttribute::Utils.unshort(shorted_uuid)
      assert_equal(random_uuid, unshorted_uuid)
    end

    def test_parser
      result = ::UuidAttribute::Utils.parse(NORMALIZED_UUID)
      assert_equal(UNORMALIZED_UUID, result)

      result = ::UuidAttribute::Utils.parse(BINARY_UUID)
      assert_equal(UNORMALIZED_UUID, result)

      result = ::UuidAttribute::Utils.parse(SHORTEN_UUID)
      assert_equal(UNORMALIZED_UUID, result)

      result = ::UuidAttribute::Utils.parse(UNORMALIZED_UUID)
      assert_equal(UNORMALIZED_UUID, result)
    end
  end
end
