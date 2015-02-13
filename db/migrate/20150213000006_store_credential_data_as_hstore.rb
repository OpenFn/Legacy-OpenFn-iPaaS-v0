class StoreCredentialDataAsHstore < ActiveRecord::Migration
  def change
    add_column :credentials, :details, :hstore
    remove_column :credentials, :api_key, :string
  end
end
