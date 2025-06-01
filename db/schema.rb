# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_05_150320) do
  create_table "build_items", force: :cascade do |t|
    t.integer "build_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_build_items_on_build_id"
    t.index ["item_id", "build_id"], name: "index_build_items_on_item_id_and_build_id", unique: true
    t.index ["item_id"], name: "index_build_items_on_item_id"
  end

  create_table "builds", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_builds_on_name", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "location"
    t.string "act"
    t.string "rarity"
    t.string "item_type"
    t.string "price"
    t.string "weight"
    t.string "effects"
    t.index ["name"], name: "index_items_on_name", unique: true
  end

  add_foreign_key "build_items", "builds"
  add_foreign_key "build_items", "items"
end
