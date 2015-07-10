class ReviewVotesController < ApplicationController

  respond_to :json, :xml
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login


  def new
    @review_vote = ReviewVote.new
  end

  def show
    @review_vote = ReviewVote.find(params[:id])
    render json: @review_vote
  end

  def index
    @reviews_votes = ReviewVote.all
    render json: @reviews_votes
  end

  def create
    @review_vote = ReviewVote.new(review_vote_params)
    respond_to do |format|
      if @review_vote.save
        format.json { render json: @review_vote, status: :created }
      else
        format.json { render json: @review_vote.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote
    if(params[:update]=="true")
      @review_vote = ReviewVote.find_by(:user_id => current_user.id, :review_id => params[:review_id])
      @review_vote.value = params[:vote]
      @review_vote.save
      render json: 0
    elsif(params[:create]=="true")
      @review_vote = ReviewVote.new(:user_id => current_user.id,
                                    :review_id => params[:review_id],
                                    :value => params[:vote])
      @review_vote.save
      render json: 0
    else
      render json: 1
    end
  end


  def count_rating
    reviews = ReviewVote.where(:review_id => params[:review_id])
    total_rating = 0
    reviews.each do |review|
      total_rating += review.value
    end
    render json: total_rating
  end

  def check_vote
    review_vote = ReviewVote.find_by(:user_id => current_user.id, :review_id => params[:review_id])
    if review_vote == nil
      render json: 0
    else
      render json: review_vote.value
    end
  end


  private

  def review_vote_params
    params.require(:review_vote).permit(:user_id, :review_id, :value)
  end

end
