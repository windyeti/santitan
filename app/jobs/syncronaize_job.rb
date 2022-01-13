class SyncronaizeJob < ApplicationJob
  queue_as :default

  def perform
    Services::Syncronaize.call

    ActionCable.server.broadcast 'status_process', {distributor: "product", process: "syncronize", status: "finish", message: "Синхронизация остатков и цен"}
  end
end
