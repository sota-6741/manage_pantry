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

ActiveRecord::Schema[8.1].define(version: 2026_01_19_081648) do
  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "inventory_logs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "change_amount", precision: 10
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.integer "reason"
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_inventory_logs_on_item_id"
  end

  create_table "items", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.date "expiration_date"
    t.string "name"
    t.decimal "quantity", precision: 8, scale: 2, default: "0.0", null: false
    t.string "unit"
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_items_on_category_id"
  end

  add_foreign_key "inventory_logs", "items"
  add_foreign_key "items", "categories"
end
