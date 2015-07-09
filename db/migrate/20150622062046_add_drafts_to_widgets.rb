class AddDraftsToWidgets < ActiveRecord::Migration
  def change
    add_column :products, :draft_id, :integer
    add_column :products, :published_at, :timestamp
    add_column :products, :trashed_at, :timestamp
    add_column :taggings, :draft_id, :integer
    add_column :taggings, :published_at, :timestamp
    add_column :taggings, :trashed_at, :timestamp
  end
end
