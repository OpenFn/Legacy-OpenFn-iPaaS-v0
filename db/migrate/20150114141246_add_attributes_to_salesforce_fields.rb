class AddAttributesToSalesforceFields < ActiveRecord::Migration
  def change
    add_column :salesforce_fields, :nillable, :boolean
    add_column :salesforce_fields, :unique, :boolean
  end
end
