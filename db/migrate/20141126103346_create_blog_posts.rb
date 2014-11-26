class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :salesforce_name
      t.text :content
      t.boolean :published
      t.datetime :publication_date 
    end
  end
end
