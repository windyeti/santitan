class SyncronaizeJob < ApplicationJob
  queue_as :default

  def perform
    Services::Syncronaize.call
  end
end
