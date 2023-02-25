class AddTables < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        # This activates the citext extension which allows us to create
        # fields that are case insensitive, but case preserving. This means
        # we can set a unique constraint on a field and values that are 
        # identical but different case will be treated as identical.
        execute %{
          CREATE EXTENSION IF NOT EXISTS citext;
        }
      end
    end
    create_table :products, comment: "List of products, prices and quantities available" do |t|
      t.citext :name, null: false, index: { unique: true },
        comment: "Name of the product"
      t.integer :quantity_remaining, null: false, comment: "How many of this product are left?"
      t.integer :price_cents, null: false, comment: "Price of one product, in cents"

      t.timestamps null: false
    end

    create_table :orders, comment: "Orders created" do |t|
      t.references :product, null: false, foreign_key: true, index: true,
        comment: "Which product is in this order?"
      t.integer :quantity, null: false, comment: "How many?"
      t.text :address, null: false, comment: "What address should it be shipped to?"
      t.text :email, null: false, comment: "What email address should be notified?"
      t.timestamps null: false
    end
  end
end
