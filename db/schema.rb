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

ActiveRecord::Schema[7.2].define(version: 2025_06_02_152228) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "nodes", force: :cascade do |t|
    t.string "name", null: false
    t.string "seal", limit: 3
    t.string "serie", limit: 3
    t.string "plate"
    t.string "status"
    t.integer "number"
    t.float "size"
    t.uuid "reference_code"
    t.text "description"
    t.string "time_slot"
    t.integer "relative_age"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_nodes_on_category_id"
    t.index ["plate"], name: "index_nodes_on_plate", unique: true
    t.index ["reference_code"], name: "index_nodes_on_reference_code", unique: true
  end

  create_table "nodes_tags", id: false, force: :cascade do |t|
    t.bigint "node_id", null: false
    t.bigint "tag_id", null: false
    t.index ["node_id", "tag_id"], name: "index_nodes_tags_on_node_id_and_tag_id", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "nodes", "categories"
end
