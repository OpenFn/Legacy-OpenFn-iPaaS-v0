class AddUserSettingsCollumnsToUser < ActiveRecord::Migration
  def change
    remove_column :users, :odk_username, :string
    remove_column :users, :odk_password, :string
    add_column :users, :odk_url, :string
    add_column :users, :sf_security_token, :string
  end
end
