class CreateSalesforceObjects < ActiveRecord::Migration
  def change
    create_table :salesforce_objects do |t|
      t.string :name
      t.string :data_type
      t.string :label
      t.string :color
      t.references :mapping, index: true

      t.timestamps
    end
  end
end
