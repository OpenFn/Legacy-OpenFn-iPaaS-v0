class RemoveSfIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :sf_id, :string
  end
end
