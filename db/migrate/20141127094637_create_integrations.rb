class CreateIntegrations < ActiveRecord::Migration
  def change
    create_table :integrations do |t|
      t.integer :user_id
      t.string :name
      t.integer :source_id
      t.integer :destination_id
    end
  end
end
