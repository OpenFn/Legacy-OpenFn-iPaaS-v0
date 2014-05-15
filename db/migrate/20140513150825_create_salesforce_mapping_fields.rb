class CreateSalesforceMappingFields < ActiveRecord::Migration
  def change
    create_table :salesforce_fields do |t|
      t.references :mapping
      t.string :object_name
      t.string :field_name
      t.timestamps
    end
  end
end
