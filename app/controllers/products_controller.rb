class ProductsController < ApplicationController
  respond_to :json, :xml
  layout false

  skip_before_filter :verify_authenticity_token, :require_login, only: [:update]

  def index
    render json: Product.enabled.order('name').as_json
  end

  def show
    product = Product.find(params[:id])
    render json: product.as_json(methods: :tag_list)
  end

  def update
    notification = Salesforce::Notification.new(request.body.read)
    salesforce_product = Salesforce::Listing::Product.new(notification)

    product = Product.from_salesforce(salesforce_product)

    if product.save
      respond_to do |format|
        format.xml  { render 'success', layout: false }
      end
    else
      respond_to do |format|
        format.xml  { render xml: "", status: 422 }
      end
    end
  end
end