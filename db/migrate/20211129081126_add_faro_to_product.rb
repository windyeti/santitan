class AddFaroToProduct < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :faro, foreign_key: true
  end
end
