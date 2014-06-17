class AddNumImportedToImports < ActiveRecord::Migration
  def change
    add_column :imports, :num_imported, :integer, default: 0
  end
end
