class AddSfHostToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sf_host, :string
  end
end
