class AddLabelNameToSalesforceFields < ActiveRecord::Migration
  def change
    add_column :salesforce_fields, :label_name, :string
  end
end
