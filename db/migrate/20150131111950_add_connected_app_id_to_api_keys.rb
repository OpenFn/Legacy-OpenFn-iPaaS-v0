class AddConnectedAppIdToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :connected_app_id, :integer
  end
end
