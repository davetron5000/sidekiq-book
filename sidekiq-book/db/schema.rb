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

ActiveRecord::Schema[7.0].define(version: 2023_02_25_183202) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "orders", comment: "Orders created", force: :cascade do |t|
    t.bigint "product_id", null: false, comment: "Which product is in this order?"
    t.integer "quantity", null: false, comment: "How many?"
    t.text "address", null: false, comment: "What address should it be shipped to?"
    t.text "email", null: false, comment: "What email address should be notified?"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_orders_on_product_id"
  end

  create_table "products", comment: "List of products, prices and quantities available", force: :cascade do |t|
    t.citext "name", null: false, comment: "Name of the product"
    t.integer "quantity_remaining", null: false, comment: "How many of this product are left?"
    t.integer "price_cents", null: false, comment: "Price of one product, in cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  add_foreign_key "orders", "products"
end
