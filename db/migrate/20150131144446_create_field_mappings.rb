class CreateFieldMappings < ActiveRecord::Migration
  def change
    create_table :field_mappings do |t|
      t.integer :mapping_id
      t.string :source_field
      t.string :destination_field
    end
  end
end
