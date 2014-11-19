class RemoveActiveSourceAndActiveDestinationFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :active_source, :boolean
    remove_column :products, :active_destination, :boolean
  end
end
