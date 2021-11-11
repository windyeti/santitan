# TODO NewDistributor
module ProductsHelper
  def distributor_exist?(product)
    true if product.abc.present?
  end

  def count_product_var(product)
    variants = Product.where(insales_id: product.insales_id).order("id DESC")
    count = variants.size
    index_var = 0
    variants.each_with_index do |variant, index|
      index_var = index if variant.insales_var_id == product.insales_var_id
    end
    {count: count, index_var: index_var + 1 }
  end

  def color_by_id(id)
    # color_id = id.to_s.split('').last
    color_id = id.to_s[/\d{2}$/]
    colors = {"0"=>"Aqua", "01"=>"Black", "02"=>"BlanchedAlmond", "03"=>"Blue", "04"=>"BlueViolet", "05"=>"Brown", "06"=>"BurlyWood", "07"=>"CadetBlue", "08"=>"Chartreuse", "09"=>"Chocolate", "10"=>"Coral",
              "11"=>"CornflowerBlue", "12"=>"Crimson", "13"=>"Cyan", "14"=>"DarkBlue", "15"=>"DarkCyan", "16"=>"DarkGoldenRod", "17"=>"DarkGreen", "18"=>"DarkGrey", "19"=>"DarkKhaki", "20"=>"DarkMagenta",
              "21"=>"DarkOliveGreen", "22"=>"DarkOrange", "23"=>"DarkRed", "24"=>"DarkSalmon", "25"=>"DarkSeaGreen", "26"=>"DarkSlateBlue", "27"=>"DarkSlateGrey", "28"=>"DarkTurquoise", "29"=>"DarkViolet", "30"=>"DeepPink",
              "31"=>"DeepSkyBlue", "32"=>"DimGrey", "33"=>"DodgerBlue", "34"=>"FireBrick", "35"=>"Fuchsia", "36"=>"Gold", "37"=>"Goldenrod", "38"=>"Gray", "39"=>"Green", "40"=>"GreenYellow",
              "41"=>"HotPink", "42"=>"IndianRed", "43"=>"Indigo", "44"=>"Khaki", "45"=>"LightBlue", "46"=>"LightCoral", "47"=>"LightGreen", "48"=>"LightPink", "49"=>"LightSalmon", "50"=>"LightSeaGreen",
              "51"=>"LightSkyBlue", "52"=>"LightSlateGrey", "53"=>"Lime", "54"=>"LimeGreen", "55"=>"Magenta", "56"=>"YellowGreen", "57"=>"MediumAquaMarine", "58"=>"MediumBlue", "59"=>"MediumOrchid", "60"=>"MediumPurple",
              "61"=>"MediumSeaGreen", "62"=>"MediumSlateBlue", "63"=>"MediumSpringGreen", "64"=>"MediumTurquoise", "65"=>"MediumVioletRed", "66"=>"Navy", "67"=>"Olive", "68"=>"OliveDrab", "69"=>"Orange", "70"=>"OrangeRed",
              "71"=>"Orchid", "72"=>"PaleGreen", "73"=>"PaleTurquoise", "74"=>"PaleVioletRed", "75"=>"Peru", "76"=>"Pink", "77"=>"Plum", "78"=>"Purple", "79"=>"RebeccaPurple", "80"=>"Red",
              "81"=>"RosyBrown", "82"=>"RoyalBlue", "83"=>"SaddleBrown", "84"=>"Salmon", "85"=>"SandyBrown", "86"=>"SeaGreen", "87"=>"Sienna", "88"=>"SkyBlue", "89"=>"SlateBlue", "90"=>"SlateGrey",
              "91"=>"SpringGreen", "92"=>"SteelBlue", "93"=>"Tan", "94"=>"Teal", "95"=>"Thistle", "96"=>"Tomato", "97"=>"Turquoise", "98"=>"Violet", "99"=>"Wheat", "100"=>"Yellow", "101"=>"Maroon"}

    colors[color_id]
  end
end
