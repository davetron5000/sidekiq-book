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

ActiveRecord::Schema[7.0].define(version: 2023_03_03_185842) do
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
    t.bigint "user_id", null: false, comment: "Which user placed and paid-for this order?"
    t.text "charge_id", comment: "If this was paid for, what was the charge id from the remote system?"
    t.text "email_id", comment: "If the email confirmation went out, what was the id in the remote system?"
    t.text "fulfillment_request_id", comment: "If the order's fulfillment was requested,, what was the id in the remote system?"
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", comment: "List of products, prices and quantities available", force: :cascade do |t|
    t.citext "name", null: false, comment: "Name of the product"
    t.integer "quantity_remaining", null: false, comment: "How many of this product are left?"
    t.integer "price_cents", null: false, comment: "Price of one product, in cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "users", comment: "Users of the system", force: :cascade do |t|
    t.citext "email", null: false, comment: "Email address of this user"
    t.text "payment_method_id", null: false, comment: "ID of the payment method in our payments service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["payment_method_id"], name: "index_users_on_payment_method_id", unique: true
  end

  add_foreign_key "orders", "products"
  add_foreign_key "orders", "users"
end
