class DropIntegrations < ActiveRecord::Migration
  def change
    drop_table :integrations
  end
end
