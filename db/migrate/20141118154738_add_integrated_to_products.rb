class AddIntegratedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :integrated, :boolean, default: false
  end
end
