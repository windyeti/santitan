class AbcImportJob < ApplicationJob
  queue_as :default

  def perform(path_file, extend_file)
    Services::AbcImport.new(path_file, extend_file).call
    ActionCable.server.broadcast 'status_process', {distributor: "abc", process: "update_distributor", status: "finish", message: "Обновление товаров поставщика Abc"}
  end
end
