class CreateSalesforceRelationships < ActiveRecord::Migration
  def change
    create_table :salesforce_relationships do |t|
      t.references :salesforce_object, index: true
      t.references :salesforce_field, index: true
      t.timestamps
    end
  end
end
