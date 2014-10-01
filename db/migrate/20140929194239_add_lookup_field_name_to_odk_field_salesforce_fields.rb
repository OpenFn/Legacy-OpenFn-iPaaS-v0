class AddLookupFieldNameToOdkFieldSalesforceFields < ActiveRecord::Migration
  def change
    add_column :odk_field_salesforce_fields, :lookup_field_name, :string
  end
end
