class AddLookupPropertyToSalesforceField < ActiveRecord::Migration
  def change
    add_column :salesforce_fields, :is_lookup, :boolean
    remove_column :salesforce_fields, :perform_lookups 
  end
end
