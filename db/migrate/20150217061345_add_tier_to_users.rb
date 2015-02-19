class AddTierToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tier, :string
  end
end
