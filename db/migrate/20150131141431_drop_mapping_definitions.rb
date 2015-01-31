class DropMappingDefinitions < ActiveRecord::Migration
  def change
    drop_table :mapping_definitions
  end
end
