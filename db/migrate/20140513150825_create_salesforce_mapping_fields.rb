class CreateSalesforceMappingFields < ActiveRecord::Migration
  def change
    create_table :salesforce_mapping_fields do |t|
      t.references :odk_mapping_field
      t.string :object_name
      t.string :field_name

      t.timestamps
    end
  end
end
