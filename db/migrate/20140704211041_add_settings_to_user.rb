class AddSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :odk_username, :string
    add_column :users, :odk_password, :string
    add_column :users, :sf_username, :string
    add_column :users, :sf_password, :string
  end
end
