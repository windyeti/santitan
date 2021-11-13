class Services::ImportProduct
  def self.call
    puts '=====>>>> СТАРТ InSales YML '+Time.now.to_s

    Product.all.each {|tov| tov.update(check: false)}

    uri = "https://santitan.ru/marketplace/87338.xml"
    response = RestClient.get uri, :accept => :xml, :content_type => "application/xml"
    data = Nokogiri::XML(response)
    offers = data.xpath("//offer")

    categories = {}
    doc_categories = data.xpath("//category")

    doc_categories.each do |c|
      categories[c["id"]] = c.text
    end


    offers.each do |pr|
      params = []
      pr.xpath("param").each do |p|
        name = p["name"]
        text = p.text
        params << "#{name}: #{text}"
      end

      data_create = {
        sku: pr.xpath("sku").text,
        title: pr.xpath("model").text,
        url: pr.xpath("url").text,
        quantity: pr.xpath("quantity").text,
        desc: pr.xpath("description").text,
        distributor: pr.xpath("brend").text,
        image: pr.xpath("picture").map(&:text).join(' '),
        cat: categories[pr.xpath("categoryId").text],
        price: pr.xpath("price").text.to_f,
        oldprice: pr.xpath("oldprice").text.to_f,
        p1: params.join(' --- '),
        insales_id: pr["group_id"],
        insales_var_id: pr["id"],
      }

      data_update = {
        sku: pr.xpath("sku").text,
        title: pr.xpath("model").text,
        url: pr.xpath("url").text,
        quantity: pr.xpath("quantity").text,
        desc: pr.xpath("description").text,
        distributor: pr.xpath("brend").text,
        image: pr.xpath("picture").map(&:text).join(' '),
        cat: categories[pr.xpath("categoryId").text],
        price: pr.xpath("price").text.to_f,
        oldprice: pr.xpath("oldprice").text.to_f,
        p1: params.join(' --- '),
        check: true,
      }
      product = Product
                  .find_by(insales_var_id: data_create[:insales_var_id])

      product.present? ? product.update(data_update) : Product.create!(data_create)
    end
    puts '=====>>>> FINISH InSales YML '+Time.now.to_s
  end
end
