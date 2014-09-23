class AddOrderToSalesforceObjects < ActiveRecord::Migration
  def change
    add_column :salesforce_objects, :order, :integer
  end
end
