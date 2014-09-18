class AddSalesforceObjectIdToSalesforceFields < ActiveRecord::Migration
  def change
    add_reference :salesforce_fields, :salesforce_object, index: true
  end
end
