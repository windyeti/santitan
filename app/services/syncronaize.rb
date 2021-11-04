class Services::Syncronaize
  def self.call
    Product.find_each(batch_size: 1000) do |product|
      abc = product.abc
      if abc.present?
        provider_price = abc.price ? abc.price : abc.purchase_price
        provider_quantity = abc.quantity
        product.update(price: provider_price, quantity: provider_quantity)
      end
    end
  end
end