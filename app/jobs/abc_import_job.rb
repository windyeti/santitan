class AbcImportJob < ApplicationJob
  queue_as :default

  def perform(path_file, extend_file)
    Services::AbcImport.new(path_file, extend_file).call
  end
end
