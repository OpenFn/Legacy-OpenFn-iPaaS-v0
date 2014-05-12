class CreateMappingFields < ActiveRecord::Migration
  def change
    create_table :mapping_fields do |t|
      t.string :odk_field_name
      t.string :odk_field_type
      t.string :salesforce_object_field_name
      t.references :mapping

      t.timestamps
    end
  end
end
