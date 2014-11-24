class CreateIntegrationDestinations < ActiveRecord::Migration
  def change
    create_table :integration_destinations do |t|
      t.integer :product_id
      t.integer :credential_id
    end
  end
end
