class CreateIntegrationSources < ActiveRecord::Migration
  def change
    create_table :integration_sources do |t|
      t.integer :product_id
      t.integer :credential_id
      t.integer :api_key_id
    end
  end
end
