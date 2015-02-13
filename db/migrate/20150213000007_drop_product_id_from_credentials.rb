class DropProductIdFromCredentials < ActiveRecord::Migration
  def change
    remove_column :credentials, :product_id, :integer
  end
end
