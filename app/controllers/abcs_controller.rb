class AbcsController < ApplicationController
  include Distributor
  
  before_action :set_abc, only: [:show]
  
  def show; end

  def update
    @abc = Abc.find(params[:id])

    respond_to do |format|
      if @abc.update(abc_params)
        format.html { redirect_to(@abc, :notice => 'ABC was successfully updated.') }
        format.json { respond_with_bip(@abc) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@abc) }
      end
    end
  end

  def import
    FileUtils.rm_rf(Dir.glob('provider/*.*'))
    uploaded_io = params[:file]

    File.open(Rails.root.join('provider', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end

    path_file = Rails.root.join('provider', uploaded_io.original_filename).to_s
    extend_file = uploaded_io.original_filename.to_s
    AbcImportJob.perform_later(path_file, extend_file)
    flash[:notice] = 'Задача импорта Товаров запущена'
    redirect_to abcs_path
  end

  private

  def set_abc
    @abc = Abc.find(params[:id])
  end

  def abc_params
    params.require(:abc).permit(:price, :quantity)
  end
end
