class AddTitleToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :title, :text
  end
end
