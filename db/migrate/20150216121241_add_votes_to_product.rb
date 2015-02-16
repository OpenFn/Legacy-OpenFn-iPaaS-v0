class AddVotesToProduct < ActiveRecord::Migration
  def change
    add_column :products, :votes, :integer
  end
end
