class ProductsController < ApplicationController
  def index
    if params[:q]
      @params = params[:q]
    else
      @params = []
    end

    @search = Product.ransack(@params)
    @search.sorts = 'id desc' if @search.sorts.empty?

    # данные для «кнопки создать csv по фильтру», все данные в отличии от @products, который ограничен 100
    @search_id_by_q = Product.ransack(@params).result.pluck(:id)

    @products = @search.result.paginate(page: params[:page], per_page: 5)

    if params['otchet_type'] == 'selected'
      Services::CsvSelected.call(@search_id_by_q)
      redirect_to '/product_selected.csv'
    end
  end

  def import_product
    ImportProductJob.perform_later
    flash[:notice] = 'Запущен процесс Обновление Товаров InSales'
    redirect_to products_path
  end

  def syncronaize
    SyncronaizeJob.perform_later
    flash[:notice] = 'Задача синхронизации каталога запущена'
    redirect_to products_path
  end

  def export_csv
    ExportCsvJob.perform_later
    flash[:notice] = 'Задача создания CSV для экспорта запущена'
    redirect_to products_path
  end
end
