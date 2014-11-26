class BlogPostsController < ApiController
  respond_to :xml

  def update
    notification = Salesforce::Notification.new(request.body.read)
    salesforce_blog_post = Salesforce::Listing::BlogPost.new(notification)

    blog_post = BlogPost.from_salesforce(salesforce_blog_post)

    if blog_post.save
      respond_to do |format|
        format.xml  { render 'salesforce/success', layout: false }
      end
    else
      respond_to do |format|
        format.xml  { render xml: "", status: 422 }
      end
    end
  end
end