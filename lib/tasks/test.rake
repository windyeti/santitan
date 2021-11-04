task rest_client: :environment do
  uri = "https://myshop-bqg173.myinsales.ru/marketplace/86818.xml"
  p response = RestClient.get(uri, :accept => :xml, :content_type => "application/xml")
  data = Nokogiri::XML(response)
  offers = data.xpath("//offer")
end
