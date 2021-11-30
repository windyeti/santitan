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
