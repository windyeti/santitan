class Services::AbcImport
  def initialize(path_file, extend_file)
    @path_file = path_file
    @extend_file = extend_file
  end

  def call
    puts '=====>>>> СТАРТ Import Abc '+Time.now.to_s
    Abc.all.each { |abc| abc.update(check: false, quantity: 0)}

    spreadsheets = open_spreadsheet
    last_spreadsheet = spreadsheets.last_row.to_i

    (2..last_spreadsheet).each do |i|
      data = {
        sku: spreadsheets.cell(i, 'A'),
        title: spreadsheets.cell(i, 'B'),
        quantity: spreadsheets.cell(i, 'C') == "более 10" ? 10 : 0,
        purchase_price: spreadsheets.cell(i, 'D'),
        price: spreadsheets.cell(i, 'E'),
        brand: spreadsheets.cell(i, 'F'),
        series: spreadsheets.cell(i, 'G'),
        check: true
      }

      abc = Abc
              .find_by(sku: data[:sku])

      if abc.present?
        abc.update(data)
      else
        abc = Abc.create(data)
      end

      linking(abc)
    end
    puts '=====>>>> FINISH Import Abc '+Time.now.to_s
  end

  def linking(abc)
    if abc.product.nil?
      product = Product.find_by(sku: abc.sku)
      abc.product = product if product.present?
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
