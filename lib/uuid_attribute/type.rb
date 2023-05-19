
module UuidAttribute
  # UUID Attribute
  class Type < ActiveModel::Type::Binary
    def type
      :uuid
    end

    def serialize(value)
       #puts "SERIALIZE"
      return if value.blank?
      return value if value.is_a?(ActiveRecord::Type::Binary::Data)

      binary_data = value
      binary_data = Utils.raw_bytes(Utils.normalize(Utils.parse(value))) if value.is_a?(String)
      # binary_data = value.raw if value.is_a?(UUID)

      ActiveRecord::Type::Binary::Data.new(
        binary_data
      )
    end

    def deserialize(value)
      # puts "DESERIALIZE"
      return nil if value.nil?
      value = value.to_s if value.is_a?(ActiveModel::Type::Binary::Data)

      # return UUID.new(Utils.normalize(Utils.parse(value)))
      return Utils.shorten(Utils.normalize(Utils.parse(value)))
      # ActiveRecord::Type::Binary::Data.new(Utils.raw_bytes(Utils.normalize(Utils.parse(value))))
    end

    def cast(value)
      # puts "CAST"
      return nil if value.nil?
      # return value if value.is_a?(UUID)

      value = value.to_s if value.is_a?(ActiveModel::Type::Binary::Data)
      return Utils.shorten(Utils.normalize(Utils.parse(value)))
      # super
    end
  end
end
