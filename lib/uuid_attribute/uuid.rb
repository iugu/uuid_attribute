# frozen_string_literal: true

module UuidAttribute
  # UUID Attribute
  class UUID < ActiveModel::Type::Binary
    def type
      :uuid
    end

    def serialize(value)
      return if value.blank?

      ActiveRecord::Type::Binary::Data.new(
        Utils.raw_bytes(Utils.normalize(Utils.parse(value)))
      )
    end

    def deserialize(value)
      return nil if value.nil?

      Utils.shorten(Utils.parse(value.to_s))
    end

    def cast(value)
      deserialize(value)
    end
  end
end
