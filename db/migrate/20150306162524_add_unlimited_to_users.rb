class AddUnlimitedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unlimited, :boolean
  end
end
