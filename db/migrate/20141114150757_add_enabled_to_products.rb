class AddEnabledToProducts < ActiveRecord::Migration
  def change
    add_column :products, :enabled, :boolean    
  end
end
