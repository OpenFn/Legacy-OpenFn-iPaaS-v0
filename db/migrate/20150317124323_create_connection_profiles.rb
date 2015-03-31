class CreateConnectionProfiles < ActiveRecord::Migration
  def change
    create_table :connection_profiles do |t|
      t.string :name
      t.integer :product_id
      t.integer :user_id
      t.integer :credential_id

      t.timestamps
    end
  end
end
