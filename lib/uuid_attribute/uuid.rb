# frozen_string_literal: true
module UuidAttribute
  # UUID Attribute
  class UUID
    def initialize(value)
      @hex = Utils.normalize(Utils.parse(value))
      @shorten = Utils.shorten(@hex)
    end

    def to_s
      @shorten
    end

    def hex
      @hex
    end

    def raw
      UuidAttribute::Utils.raw_bytes(@hex)
    end
  end
end
