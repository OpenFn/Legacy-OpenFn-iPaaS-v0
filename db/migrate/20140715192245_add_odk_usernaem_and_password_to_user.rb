class AddOdkUsernaemAndPasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :odk_username, :string
    add_column :users, :odk_password, :string
  end
end
