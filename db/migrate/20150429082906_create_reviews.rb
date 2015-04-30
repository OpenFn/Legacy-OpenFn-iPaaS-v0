class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user, index: true
      t.references :product, index: true
      t.string :review
      t.float :rating
      t.date :date
      t.timestamps
    end
  end
end
