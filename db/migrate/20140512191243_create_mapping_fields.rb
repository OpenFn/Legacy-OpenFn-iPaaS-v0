class CreateMappingFields < ActiveRecord::Migration
  def change
    create_table :odk_fields do |t|
      t.string :field_name
      t.string :field_type
      t.references :salesforce_field
      t.timestamps
    end
  end
end
