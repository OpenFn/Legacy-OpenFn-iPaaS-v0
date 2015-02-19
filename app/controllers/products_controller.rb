class ProductsController < ApplicationController
  respond_to :json, :xml
  layout false

  skip_before_filter :verify_authenticity_token, only: [:update]
  before_filter :validate_api_admin, only: [:update]

  skip_before_filter :require_login, except: [:vote]

  def index
    render json: Product.enabled.order(:name).map { |p|
        p.as_json(methods: [:votes_count, :tag_list]).
          merge "hasVoteForUser" => p.has_vote_for(current_user)
      }
  end

  def show
    product = Product.find(params[:id])
    render json: product.as_json(methods: [:votes_count, :tag_list]).
      merge("hasVoteForUser" => product.has_vote_for(current_user))
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
    if product.has_vote_for(current_user)
      product.votes.where(user: current_user).destroy_all
    else
      product.votes.create!(user: current_user)
    end

    render json: product.as_json(methods: [:votes_count, :tag_list]).
      merge("hasVoteForUser" => product.has_vote_for(current_user))
  end

end
