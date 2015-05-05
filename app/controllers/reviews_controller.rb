class ReviewsController < ApplicationController

  respond_to :json, :xml
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login

  def new
    @review = Review.new
    @review = Review.find(:all)
  end

  def show
    @review = Review.find(params[:id])
    #render json: @review
  end

  def index
    @reviews = Review.where(:product_id => params[:product_id])
    #render json: @reviews
  end

  def create
    @review = Review.new(review_params)
    respond_to do |format|
      if @review.save
        #format.json { render json: @review, status: :created }
        redirect_to :action => 'index'
      else
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:user_id, :product_id, :review, :rating, :date)
  end

end
