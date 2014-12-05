class AddEnabledToMappings < ActiveRecord::Migration
  def change
    add_column :mappings, :enabled, :boolean
  end
end
