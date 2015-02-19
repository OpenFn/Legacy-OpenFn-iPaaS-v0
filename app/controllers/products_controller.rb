class ProductsController < ApplicationController
  respond_to :json, :xml
  layout false

  skip_before_filter :verify_authenticity_token, only: [:update]
  before_filter :validate_api_admin, only: [:update]

  skip_before_filter :require_login

  def index
    render json: Product.enabled.order('name').as_json(methods: :tag_list)
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
        format.xml  { render 'salesforce/success', layout: false }
      end
    else
      respond_to do |format|
        format.xml  { render xml: "", status: 422 }
      end
    end
  end

  def vote
    product = Product.find(params[:product_id])
    if current_user
      vote = Vote.where(:user_id => current_user.id, :product_id => product.id).first
      if vote.present?
       vote.destroy
      else
      Vote.create(:user_id => current_user.id, :product_id => product.id)    
      end
      render json: product.as_json(methods: :votes_count).merge("hasVoteForUser" => product.has_vote_for(current_user))
    else
      render json: product.as_json(methods: :votes_count).merge("current_user" => 0)
    end
  end

  def checkuser
    if current_user
      render json: current_user.id
    else
      render json: 0
    end
  end

end