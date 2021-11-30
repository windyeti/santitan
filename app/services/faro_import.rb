class Services::FaroImport
  def initialize(path_file, extend_file)
    @path_file = path_file
    @extend_file = extend_file
  end

  def call
    puts '=====>>>> СТАРТ Import Faro '+Time.now.to_s
    Faro.all.each { |abc| abc.update(check: false, quantity: 0)}

    spreadsheets = open_spreadsheet
    last_spreadsheet = spreadsheets.last_row.to_i

    (2..last_spreadsheet).each do |i|

      quantity = spreadsheets.cell(i, 'E').to_i >= 5 ? spreadsheets.cell(i, 'E').to_i : 0
      purchase_price = spreadsheets.cell(i, 'D')
      price = (purchase_price.to_f + purchase_price.to_f / 100 * 42).ceil

      puts data = {
        sku: spreadsheets.cell(i, 'B'),
        title: spreadsheets.cell(i, 'C'),
        quantity: quantity,
        purchase_price: purchase_price,
        price: price,
        brand: spreadsheets.cell(i, 'A'),
        check: true
      }

      faro = Faro
              .find_by(sku: data[:sku])

      if faro.present?
        faro.update(data)
      else
        faro = Faro.create(data)
      end

      linking(faro)
    end
    puts '=====>>>> FINISH Import Faro '+Time.now.to_s
  end

  def linking(faro)
    products = Product.where(sku: faro.sku)
    products.each do |product|
      product.faro = faro
      product.save
    end
  end

  def open_spreadsheet
    case @extend_file.split('.').last
    when "csv" then Roo::Spreadsheet.open(@path_file, { csv_options: { col_sep: ";", quote_char: '|'} })
    # when "csv" then Roo::Spreadsheet.open(path_file, { csv_options: { encoding: 'bom|utf-8', col_sep: "\t" } })
    when "xls" then Roo::Excel.new(@path_file)
    when "xlsx" then Roo::Excelx.new(@path_file)
    when "XLS" then Roo::Excel.new(@path_file)
    else raise "Unknown file type"
    end
  end
end
