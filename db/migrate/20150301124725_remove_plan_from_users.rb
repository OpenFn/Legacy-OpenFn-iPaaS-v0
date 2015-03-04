class RemovePlanFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :plan_id, :integer
  end
end
