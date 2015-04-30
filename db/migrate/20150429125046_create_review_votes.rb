class CreateReviewVotes < ActiveRecord::Migration
  def change
    create_table :review_votes do |t|
      t.references :user, index: true
      t.references :review, index: true
      t.integer :value
      t.timestamps
    end
  end
end
