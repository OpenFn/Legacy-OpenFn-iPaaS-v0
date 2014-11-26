class BlogPost < ActiveRecord::Base
  validates :salesforce_name, presence: true
  validates :content, presence: true
  validates :publication_date, presence: true

  scope :published, -> { where(published: true) }

  def self.from_salesforce(salesforce_blog_post)
    blog_post = where(salesforce_name: salesforce_blog_post.salesforce_name).first_or_initialize
    
    blog_post.content = salesforce_blog_post.content
    blog_post.published = salesforce_blog_post.published
    blog_post.publication_date = salesforce_blog_post.publication_date

    return blog_post
  end
end