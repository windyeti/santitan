class FaroImportJob < ApplicationJob
  queue_as :default

  def perform(path_file, extend_file)
    Services::FaroImport.new(path_file, extend_file).call
  end
end
