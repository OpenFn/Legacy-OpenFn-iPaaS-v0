class AddPlanRefToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :plan, index: true
  end
end