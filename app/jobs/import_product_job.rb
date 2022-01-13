class ImportProductJob < ApplicationJob
  queue_as :default

  def perform
    Services::ImportProduct.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "update_product", status: "finish", message: "Обновление товаров из InSales"}

    # data_email = {
    #   email: 'mm062@mail.ru',
    #   subject: 'Оповещение: Закончено обновление Товаров SanTitan',
    #   body: 'Закончено обновление Товаров SanTitan'
    # }
    # NotificationMailer.notify(data_email).deliver_later
  end
end
