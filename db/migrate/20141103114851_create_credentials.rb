class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.string :api_key
      t.integer :product_id
      t.integer :user_id

      t.timestamps
    end
  end
end
