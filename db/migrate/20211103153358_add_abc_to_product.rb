class AddAbcToProduct < ActiveRecord::Migration[5.2]
  def change
    add_reference :products, :abc, foreign_key: true
  end
end
