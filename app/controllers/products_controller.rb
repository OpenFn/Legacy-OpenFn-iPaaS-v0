class ProductsController < ApplicationController
  respond_to :json
  layout false

  skip_before_filter :verify_authenticity_token, :require_login

  def index
    render json: Product.order('name').as_json
  end

  def update
    notification = Salesforce::Notification.new(request.body.read)
    salesforce_product = Salesforce::Listing::Product.new(notification)

    product = Product.from_salesforce(salesforce_product)

    if product.save
      respond_to do |format|
        format.xml  { render xml: "" }
      end
    else
      respond_to do |format|
        format.xml  { render xml: "" }
      end
    end
  end
end