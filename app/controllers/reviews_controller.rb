class ReviewsController < ApplicationController

  respond_to :json, :xml
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login

  def new
    @review = Review.new
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
    Rails.logger.info {"#{__FILE__}:#{__LINE__} #{params[:review]}, #{params[:rating]}, #{params[:product_id]}, #{current_user.id}"}
    @review = Review.new(:review => params[:review],
                         :rating => params[:rating],
                         :product_id => params[:product_id],
                         :user_id => current_user.id,
                         :date => Time.now.to_date)
    #respond_to do |format|
      if @review.save
        #format.json { render json: @review, status: :created }
        redirect_to :controller => 'reviews', :action => 'index', :product_id => params[:product_id]
      else
        format.json { render json: @review.errors, status: :unprocessable_entity }
        render :action => 'new'
      end
    #end
  end


end
