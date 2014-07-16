class AddValidCredentialsFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :valid_credentials, :boolean, default: false
    User.update_all valid_credentials: false
  end
end
