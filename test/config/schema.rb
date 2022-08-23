# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table "samples", id: :binary, limit: 16, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "examples", id: :binary, limit: 16, force: :cascade do |t|
    t.string "name"
    t.references :sample, null: false, foreign_key: false, type: :binary, limit: 16
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
