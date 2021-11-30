class CreateFaros < ActiveRecord::Migration[5.2]
  def change
    create_table :faros do |t|
      t.string   "title"
      t.string   "sku"
      t.integer   "quantity"
      t.float    "purchase_price"
      t.float    "price"
      t.string   "brand"
      t.boolean  "check",      default: true

      t.timestamps
    end
  end
end
