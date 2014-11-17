class RemoveLogosFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :logo_path, :string
    remove_column :products, :inactive_logo_path, :string
  end
end
