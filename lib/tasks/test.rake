task rest_client: :environment do
  uri = "https://myshop-bqg173.myinsales.ru/marketplace/86818.xml"
  p response = RestClient.get(uri, :accept => :xml, :content_type => "application/xml")
  # p response = RestClient::Request.execute(:url => uri, :method => :get, :verify_ssl => false, :accept => :xml, :content_type => "application/xml")
  # data = Nokogiri::XML(response)
  # offers = data.xpath("//offer")
end

task uniq: :environment do
  a = Product.all.map(&:sku)
  p a.uniq.
    map { | e | [a.count(e), e] }.
    select { | c, _ | c > 1 }.
    sort.reverse.
    map { | c, e | "#{e}:#{c}" }
end

task nova: :environment do
  FileUtils.rm Dir.glob("#{Rails.public_path}/nova_abc.csv")
  shop_rows = CSV.read("#{Rails.public_path}/shop.csv", headers: true)
  shop_skus = shop_rows.map {|row| row["Артикул"]}
  nova_rows = CSV.read("#{Rails.public_path}/nova.csv", headers: true)

  CSV.open("#{Rails.public_path}/nova_abc.csv", "a+") do |csv|
    csv << nova_rows.first.to_hash.keys
    nova_rows.each do |nova_row|
      next if shop_skus.include?(nova_row["Артикул"])
      csv << nova_row
    end
  end
end
