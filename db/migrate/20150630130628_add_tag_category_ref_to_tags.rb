class AddTagCategoryRefToTags < ActiveRecord::Migration
  def change
    add_reference :tags, :tag_category, index: true
  end
end
