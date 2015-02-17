class AddSfIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sf_id, :string
  end
end
