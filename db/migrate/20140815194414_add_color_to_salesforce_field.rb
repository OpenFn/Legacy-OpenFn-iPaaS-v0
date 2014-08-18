class AddColorToSalesforceField < ActiveRecord::Migration
  def change
    add_column :salesforce_fields, :color, :string
  end
end
