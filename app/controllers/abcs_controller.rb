class AbcsController < ApplicationController
  before_action :set_abc, only: [:show]

  include Distributor

  def show; end

  def import
    FileUtils.rm_rf(Dir.glob('public/stock.csv'))
    uploaded_io = params[:file]
    File.open(Rails.root.join('public', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    path_file = Rails.root.join('public', uploaded_io.original_filename).to_s
    extend_file = uploaded_io.original_filename.to_s
    AbcImportJob.perform_later(path_file, extend_file)
    flash[:notice] = 'Задача импорта Товаров запущена'
    redirect_to abcs_path
  end

  private

  def set_abc
    @abc = Abc.find(params[:id])
  end
end
