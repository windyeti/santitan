class FarosController < ApplicationController
  include Distributor

  before_action :set_faro, only: [:show]

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

  private

  def set_faro
    @faro = Faro.find(params[:id])
  end

  def faro_params
    params.require(:faro).permit(:price, :quantity)
  end
end
