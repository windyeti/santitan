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

      quantity_cell = spreadsheets.cell(i, 'C')

      if quantity_cell.match(/10/)
        quantity = 10
      elsif quantity_cell.match(/9/)
        quantity = 9
      elsif quantity_cell.match(/8/)
        quantity = 8
      elsif quantity_cell.match(/7/)
        quantity = 7
      elsif quantity_cell.match(/6/)
        quantity = 6
      elsif quantity_cell.match(/5/)
        quantity = 5
      else
        quantity = 0
      end

      data = {
        sku: spreadsheets.cell(i, 'A'),
        title: spreadsheets.cell(i, 'B'),
        quantity: quantity,
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
    products = Product.where(sku: abc.sku)
    products.each do |product|
      product.abc = abc
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
