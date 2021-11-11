class ImportProductJob < ApplicationJob
  queue_as :default

  def perform
    Services::ImportProduct.call
    # data_email = {
    #   email: 'mm062@mail.ru',
    #   subject: 'Оповещение: Закончено обновление Товаров SanTitan',
    #   body: 'Закончено обновление Товаров SanTitan'
    # }
    # NotificationMailer.notify(data_email).deliver_later
  end
end
