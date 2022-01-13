class ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy, :show]

  def index
    if params[:q]
      @params = params[:q]
      # @params[:combinator] = 'or'

      @params.delete(:abc_id_not_null) if @params[:abc_id_not_null] == '0'
      @params.delete(:abc_id_null) if @params[:abc_id_null] == '0'

      # делаем доступные параметры фильтров, чтобы их поместить их в параметр q «кнопки создать csv по фильтру»
      @params_q_to_csv = @params.permit(:sku_or_title_cont,
                                        :distributor_eq,
                                        :quantity_eq,
                                        :price_gteq,
                                        :price_lteq,
                                        :abc_id_eq,
                                        :faro_id_eq,
                                        :abc_id_or_faro_id_not_null,
                                        :abc_id_and_faro_id__null,
      )
    else
      @params = []
    end

    @search = Product.ransack(@params)
    @search.sorts = 'id desc' if @search.sorts.empty?

    # данные для «кнопки создать csv по фильтру», все данные в отличии от @products, который ограничен 100
    @search_id_by_q = Product.ransack(@params_q_to_csv).result.pluck(:id)

    @products = @search.result.paginate(page: params[:page], per_page: 100)

    if params['otchet_type'] == 'selected'
      Services::CsvSelected.call(@search_id_by_q)
      redirect_to '/product_selected.csv'
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to(@product, :notice => 'Product was successfully updated.') }
        format.json { respond_with_bip(@product) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@product) }
      end
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
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "update_product", status: "start", message: "Обновление товаров из InSales"}

    ImportProductJob.perform_later
    # redirect_to products_path, notice: 'Запущен процесс Обновление Товаров InSales'
  end

  def syncronaize
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "syncronize", status: "start", message: "Синхронизация остатков и цен"}

    SyncronaizeJob.perform_later
    # flash[:notice] = 'Задача синхронизации каталога запущена'
    # redirect_to products_path
  end

  def export_csv
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "export_csv", status: "start", message: "Создание Csv-файла для экспорта"}

    ExportCsvJob.perform_later
    # flash[:notice] = 'Задача создания CSV для экспорта запущена'
    # redirect_to products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:sku, :title, :desc, :cat, :oldprice, :price, :quantity, :image, :url, :abc_id, :faro_id)
  end
end
