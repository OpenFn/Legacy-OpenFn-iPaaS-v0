class RemoveFluffFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :salesforce_id, :string
    remove_column :products, :reviews, :string
    remove_column :products, :provider, :string
    remove_column :products, :update_link, :string
    remove_column :products, :detail_active, :boolean
    remove_column :products, :sf_link, :string
    remove_column :products, :facebook, :string
  end
end
