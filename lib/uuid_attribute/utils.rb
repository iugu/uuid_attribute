# frozen_string_literal: true

module UuidAttribute
  # UUID Utils
  class Utils
    class << self
      def normalize(uuid_string)
        uuid_string.gsub("-", "").upcase
      end

      def hex_from_binary(bytes)
        bytes.unpack1("H*")
      end

      def mysql_value(value)
        "x'#{value}'"
      end

      def raw_bytes(uuid_string)
        [uuid_string].pack("H*")
      end

      def parse(str)
        return nil if str.length.zero?

        case str.length
        when 36
          normalize(str)
        when 16
          normalize(hex_from_binary(str))
        when 20, 21, 22
          unshort(str)
        end
      end

      DEFAULT_BASE62 = %w[
        0 1 2 3 4 5 6 7 8 9
        A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
        a b c d e f g h i j k l m n o p q r s t u v w x y z
      ].freeze

      def shorten(decimal, alphabet = DEFAULT_BASE62)
        alphabet = alphabet.to_a
        radix = alphabet.length
        normalized_decimal = normalize(decimal).to_i(16)
        i = normalized_decimal.to_i
        out = []
        return alphabet[0] if i.zero?

        loop do
          break if i.zero?

          out.unshift(alphabet[i % radix])
          i /= radix
        end
        out.join.rjust(22, "0")
      end

      def unshort(word, alphabet = DEFAULT_BASE62)
        num = 0
        radix = alphabet.length
        word.chars.to_a.reverse.each_with_index do |char, index|
          num += alphabet.index(char) * (radix**index)
        end

        uuid = num.to_s(16).rjust(32, "0")
        [
          uuid[0..7],
          uuid[8..11],
          uuid[12..15],
          uuid[16..19],
          uuid[20..31]
        ].join("-")
      end
    end
  end
end
