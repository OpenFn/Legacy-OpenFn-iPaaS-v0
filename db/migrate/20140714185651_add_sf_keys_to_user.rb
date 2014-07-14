class AddSfKeysToUser < ActiveRecord::Migration
  def change
    add_column :users, :sf_app_secret, :string
    add_column :users, :sf_app_key, :string
  end
end
