class AddDetailActiveToProducts < ActiveRecord::Migration
  def change
    add_column :products, :detail_active, :boolean
  end
end
