class ProductsController < ApplicationController
  respond_to :json, :xml
  layout false

  skip_before_filter :verify_authenticity_token, only: [:update]
  before_filter :validate_api_admin, only: [:update]

  skip_before_filter :require_login, except: [:vote, :review]

  def index
    render json: Product.enabled.order(:name).map { |p|
        p.as_json(only: [:id, :name, :website, :description, :integrated],
          methods: [:votes_count, :tag_list, :reviews_count, :rating]).
          merge "hasVoteForUser" => p.has_vote_for(current_user)
          # merge "hasReviewForUser" => p.has_review_for(current_user)
      }
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
    product.draft_update
    render json: product
  end

end
