class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :title
      t.string :desc
      t.string :cat
      t.decimal :oldprice
      t.decimal :price
      t.integer :quantity
      t.string :image
      t.string :url
      t.bigint :insales_id
      t.bigint :insales_var_id
      t.string :distributor
      t.string :p1
      t.boolean :check, default: true

      t.timestamps
    end
  end
end
