class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy, :show]

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

    @products = @search.result.paginate(page: params[:page], per_page: 100)

    if params['otchet_type'] == 'selected'
      Services::CsvSelected.call(@search_id_by_q)
      redirect_to '/product_selected.csv'
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to products_path
    else
      render :edit
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { render json: { title: @product.title }, status: :ok }
      format.js
    end
  end

  def import_product
    ImportProductJob.perform_later
    redirect_to products_path, notice: 'Запущен процесс Обновление Товаров InSales'
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

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :title, :desc, :cat, :oldprice, :price, :quantity, :image, :url, :abc_id)
  end
end
