class Services::ExportCsv
  def self.call
    file = "#{Rails.root}/public/export_insales.csv"
    check = File.file?(file)
    if check.present?
      File.delete(file)
    end
    # TODO NewDistributor
    products = Product
                 .where.not(abc: nil)
                 .or(Product.where.not(faro: nil))
                 .order(:id)

    CSV.open("#{Rails.root}/public/export_insales.csv", "wb") do |writer|
      headers = ['fid', 'Артикул', 'Название товара', 'Полное описание', 'Производитель', 'Цена продажи', 'Цена старая',
                 'Остаток', 'Изображения', 'Url', 'Подкатегория 1', 'ID товара в InSales', 'ID варианта товара в InSales']

      writer << headers
      products.each do |pr|
        fid = pr.id
        sku = pr.sku
        title = pr.title
        desc = pr.desc
        distributor = pr.distributor
        price = pr.price
        oldprice = pr.oldprice
        quantity = pr.quantity
        image = pr.image
        url = pr.url
        cat = pr.cat
        insales_id = pr.insales_id
        insales_var_id = pr.insales_var_id

        writer << [fid, sku, title, desc, distributor, price, oldprice, quantity, image, url, cat, insales_id, insales_var_id]
      end
    end #CSV.open
  end
end
