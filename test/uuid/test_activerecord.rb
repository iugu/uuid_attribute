# frozen_string_literal: true

require "test_helper"

class Sample < ActiveRecord::Base
end

class Example < ActiveRecord::Base
  belongs_to :sample
end

module UUID
  class TestActiveRecord < Minitest::Test
    def setup
      UuidAttribute::Railtie.config.after_initialize.each do |block|
        next unless block && block[0]
        next unless block[0].source_location[0].include? "uuid_attribute"

        block[0].call
      end
    end

    def test_uuid_generation
      result = Sample.new
      refute_nil(result.id)
    end

    def test_new_and_finds
      result = Sample.create(name: "A Name")
      assert(result.name, "A Name")
      refute_nil(result.id)
      assert(Sample.find(result.id).name, "A Name")
    end

    def test_references
      record_a = Sample.create(name: "Sample")
      record_b = Example.create(name: "Example on Sample", sample: record_a)
      assert(record_b.sample)
      assert(record_b.sample.id, record_a.id)
    end
  end
end
