class CreateConnectedApps < ActiveRecord::Migration
  def change
    create_table :connected_apps do |t|
      t.string :name
      t.integer :product_id
      t.integer :user_id
    end
  end
end
