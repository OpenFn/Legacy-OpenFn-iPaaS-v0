class AddIsRepeatToSalesforceObject < ActiveRecord::Migration
  def change
    add_column :salesforce_objects, :is_repeat, :boolean, default: false
  end
end
