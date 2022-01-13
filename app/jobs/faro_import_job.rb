class FaroImportJob < ApplicationJob
  queue_as :default

  def perform(path_file, extend_file)
    Services::FaroImport.new(path_file, extend_file).call
    ActionCable.server.broadcast 'status_process', {distributor: "faro", process: "update_distributor", status: "finish", message: "Обновление товаров поставщика Faro"}
  end
end
