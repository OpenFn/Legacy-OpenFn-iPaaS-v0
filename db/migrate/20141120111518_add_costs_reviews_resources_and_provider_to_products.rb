class AddCostsReviewsResourcesAndProviderToProducts < ActiveRecord::Migration
  def change
    add_column :products, :costs, :text
    add_column :products, :reviews, :text
    add_column :products, :resources, :text
    add_column :products, :provider, :text
  end
end
