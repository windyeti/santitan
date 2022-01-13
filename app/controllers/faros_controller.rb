class FarosController < ApplicationController
  include Distributor

  # before_action :set_faro, only: [:show]

  def show; end

  def update
    @faro = Faro.find(params[:id])

    respond_to do |format|
      if @faro.update(abc_params)
        format.html { redirect_to(@faro, :notice => 'Faro was successfully updated.') }
        format.json { respond_with_bip(@faro) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@faro) }
      end
    end
  end

  def import
    ActionCable.server.broadcast 'status_process', {distributor: "faro", process: "update_distributor", status: "start", message: "Обновление товаров поставщика Faro"}

    FileUtils.rm_rf(Dir.glob('public/faro/*.*'))
    uploaded_io = params[:file]

    File.open(Rails.root.join('public', 'faro', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    path_file = Rails.root.join('public', 'faro', uploaded_io.original_filename).to_s
    extend_file = uploaded_io.original_filename.to_s
    FaroImportJob.perform_later(path_file, extend_file)
    flash[:notice] = 'Задача импорта Товаров запущена'
    redirect_to faros_path
  end

  def price_edit
    if params[:ids].present?
      @faros = Faro.find(params[:ids])
      respond_to do |format|
        format.js
      end
    else
      redirect_to faros_path
    end
  end

  def price_update
    faros = Faro.find(params[:ids])
    price_move = params[:product_price][:price_move]
    price_shift = params[:product_price][:price_shift]
    price_points = params[:product_price][:price_points]

    faros.each do |faro|
      salePrice = faro.price.present? ? faro.price : 0
      price_shift = price_shift.to_f
      if price_points == "fixed"
        new_price = (salePrice.send(price_move, price_shift)).round
      else
        new_price = (salePrice.send(price_move, price_shift*0.01*salePrice)).round
      end
      faro.update(price: new_price)
    end
    redirect_to faros_path
  end

  private

  def set_faro
    @faro = Faro.find(params[:id])
  end

  def faro_params
    params.require(:faro).permit(:price, :quantity)
  end
end
