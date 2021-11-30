class Faro < ApplicationRecord
  has_many :products
  scope :product_all_size, -> { order(:id).size }
end
