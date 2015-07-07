class CreateNewMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|
      t.string :name
      t.integer :source_connected_app_id
      t.integer :destination_connected_app_id
      t.boolean :active
      t.boolean :enabled

      t.timestamps
    end
  end
end