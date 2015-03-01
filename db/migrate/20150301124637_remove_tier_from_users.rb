class RemoveTierFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :tier, :string
  end
end
