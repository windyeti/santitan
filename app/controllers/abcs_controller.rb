class AbcsController < ApplicationController
  include Distributor

  def show
  end

  def edit
  end

  def update
  end

  def import
    FileUtils.rm_rf(Dir.glob('public/provider/*'))
    uploaded_io = params[:file]
    File.open(Rails.root.join('public', 'provider', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    path_file = Rails.root.join('public', 'provider', uploaded_io.original_filename).to_s
    extend_file = uploaded_io.original_filename.to_s
    AbcImportJob.perform_later(path_file, extend_file)
    flash[:notice] = 'Задача импорта Товаров запущена'
    redirect_to abcs_path
  end
end
