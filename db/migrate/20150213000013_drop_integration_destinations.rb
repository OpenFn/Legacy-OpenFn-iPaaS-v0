class DropIntegrationDestinations < ActiveRecord::Migration
  def change
    drop_table :integration_destinations
  end
end
