class ExportCsvJob < ApplicationJob
  queue_as :default

  def perform
    Services::ExportCsv.call
  end
end
