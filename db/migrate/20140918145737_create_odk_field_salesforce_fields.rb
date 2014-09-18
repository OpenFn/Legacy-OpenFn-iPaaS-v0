class CreateOdkFieldSalesforceFields < ActiveRecord::Migration
  def change
    create_table :odk_field_salesforce_fields do |t|
      t.references :odk_field, index: true
      t.references :salesforce_field, index: true
      t.timestamps
    end
  end
end
