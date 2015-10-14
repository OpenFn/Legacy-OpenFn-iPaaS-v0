class ProductsController < ApplicationController
  respond_to :json, :xml
  layout false

  skip_before_filter :verify_authenticity_token, only: [:update]
  before_filter :validate_api_admin, only: [:update]

  skip_before_filter :require_login, except: [:vote, :review]

  def index
    enabled_products = Product.where(:enabled => 'true')
    render json: enabled_products.map { |p| p.export_to_hash(current_user) }
  end

  def show
    product = Product.find(params[:id])
    render json: product.as_json(methods: [:votes_count, :tag_list]).
      merge("hasVoteForUser" => product.has_vote_for(current_user))
      # merge("hasReviewForUser" => product.has_review_for(current_user))
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

  def review
    product = Product.find(params[:product_id])
    if product.has_review_for(current_user)
      product.reviews.where(user: current_user).destroy_all
    else
      product.reviews.create!(user: current_user, rating: rating, text: text)
    end

    render json: product.as_json(methods: [:reviews_count, :tag_list]).
      merge("hasReviewForUser" => product.has_review_for(current_user))
  end

  def get
    product = Product.find(params[:product_id])
    render json: product.to_json
  end

  def admin_edit
    product = Product.find(params[:id])
    product.name = params[:name]
    product.website = params[:website]
    product.twitter = params[:twitter]
    product.email = params[:email]
    product.description = params[:description]
    product.detailed_description = params[:detailed_description]
    product.tech_specs = params[:tech_specs]
    product.costs = params[:costs]
    product.resources = params[:resources]
    product.logo_url = params[:logo_url]
    product.draft_update
    render json: product
  end

  def admin_new
    product = Product.new
    product.name = params[:name]
    product.logo_url = params[:logo_url]
    product.website = params[:website]
    product.twitter = params[:twitter]
    product.email = params[:email]
    product.description = params[:description]
    product.detailed_description = params[:detailed_description]
    product.tech_specs = params[:tech_specs]
    product.costs = params[:costs]
    product.resources = params[:resources]
    product.draft_creation
    render json: product
  end

end
