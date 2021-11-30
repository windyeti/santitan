class Product < ApplicationRecord
  belongs_to :abc, optional: true
  belongs_to :faro, optional: true

  scope :product_all_size, -> { order(:id).size }
  scope :product_qt_not_null, -> { where('quantity > 0') }
  scope :product_qt_not_null_size, -> { where('quantity > 0').size }
  scope :product_cat, -> { order('cat DESC').select(:cat).uniq }
  scope :product_image_nil, -> { where(image: [nil, '']).order(:id) }

  DISTRIBUTOR = [
    ["faro_id_not_null", "Faro"],
    ["abc_id_not_null", "ABC"],
    ["abc_id_and_faro_id_null", "Unsync"],
    ["abc_id_or_faro_id_not_null", "Sync"],
  ]

  validate :new_distributor_empty, on: :update

  def new_distributor_empty
    if abc_id.present?
      abc = Abc.find_by(id: abc_id)
      if abc.nil?
        errors.add(:abc_id, "Товар поставщика не существует")
      end
    end
    if faro_id.present?
      faro = Faro.find_by(id: faro_id)
      if faro.nil?
        errors.add(:faro_id, "Товар поставщика не существует")
      end
    end
  end
end
