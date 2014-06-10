class AddPerformLookupsToSalesforceFields < ActiveRecord::Migration
  def change
    add_column :salesforce_fields, :perform_lookups, :boolean, default: false
  end
end
