class AddActiveBooleanToMappings < ActiveRecord::Migration
  def change
    add_column :mappings, :active, :boolean, default: false
  end
end
