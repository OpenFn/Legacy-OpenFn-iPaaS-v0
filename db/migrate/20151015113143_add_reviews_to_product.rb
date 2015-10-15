class AddReviewsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :reviews, :string
  end
end
