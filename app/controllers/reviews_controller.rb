class ReviewsController < ApplicationController

  respond_to :json, :xml
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login

  def new
    @review = Review.new
  end

  def show
    @review = Review.find(params[:id])
    render json: @review
  end

  def index
    @reviews = Review.where(:product_id => params[:product_id])
    #render json: @reviews
  end

  def create
    if !current_user.present?
      redirect_to :controller => 'user_sessions', :action => 'create'
      return
    end
    @review = Review.new(:review => params[:review],
                         :rating => params[:rating],
                         :product_id => params[:product_id],
                         :user_id => current_user.id,
                         :date => Time.now.to_date)
    #respond_to do |format|
      if @review.save
        #format.json { render json: @review, status: :created }
        redirect_to :back
      else
        redirect_to :back
        #format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    #end
  end

  def product_rating
    reviews = Review.where(:product_id => params[:product_id])
    if reviews.present?
      reviews_count = reviews.count
      Rails.logger.info {"#{__FILE__}:#{__LINE__} reviews_count => #{reviews_count}"}
      rating = reviews.sum('rating')/reviews_count
      Rails.logger.info {"#{__FILE__}:#{__LINE__} rating => #{rating}"}
      render json: rating
    else
      render json: 0
    end

  end


end
