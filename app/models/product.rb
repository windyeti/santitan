class Product < ApplicationRecord
  belongs_to :abc, optional: true

  scope :product_all_size, -> { order(:id).size }
  scope :product_qt_not_null, -> { where('quantity > 0') }
  scope :product_qt_not_null_size, -> { where('quantity > 0').size }
  scope :product_cat, -> { order('cat DESC').select(:cat).uniq }
  scope :product_image_nil, -> { where(image: [nil, '']).order(:id) }

  DISTRIBUTOR = [
    ["abc_id_not_null", "ABC"],
    ["abc_id_null", "Unsync"],
    ["abc_id_not_null", "Sync"],
  ]

  validate :new_distributor_empty, on: :update

  def new_distributor_empty
    if abc_id.present?
      abc = Abc.find_by(id: abc_id)
      if abc.nil?
        errors.add(:abc_id, "Товар поставщика не существует")
      end
    end
  end
end
