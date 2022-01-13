class ExportCsvJob < ApplicationJob
  queue_as :default

  def perform
    Services::ExportCsv.call
    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "export_csv", status: "finish", message: "Создание Csv-файла для экспорта"}
  end
end
