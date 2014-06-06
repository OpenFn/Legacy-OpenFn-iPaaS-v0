class AddSalesforceDataTypeToSalesforceFields < ActiveRecord::Migration
  def change
    add_column :salesforce_fields, :data_type, :string
  end
end
