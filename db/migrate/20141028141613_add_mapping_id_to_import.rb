class AddMappingIdToImport < ActiveRecord::Migration
  def change
    add_reference :imports, :mapping, index: true
  end
end
