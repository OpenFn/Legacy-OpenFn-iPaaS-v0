class CreateMappingFields < ActiveRecord::Migration
  def change
    create_table :odk_mapping_fields do |t|
      t.string :field_name
      t.string :field_type
      t.references :mapping

      t.timestamps
    end
  end
end
