class WelcomeStatsController < ApplicationController

  def show
    render json: {
      #hard code a plus 35k for KGVK's pre-changeover submissions
      submissionCount: Submission.where(state: 'success').count + 35000,
      userCount:       
    }
  end

  def count
    render json: {
      count: Submission.where(state: 'success').count + 35000
      #hard code a plus 35k for KGVK's pre-changeover submissions
    }
  end

end



  def public_count
    render json: {
      count: User.where(role: 'client').count
    }
  end

    def public_count
    render json: {
      count: Product.where(enabled: true).count
    }
  end

  def public_connected_count
    render json: {
      count: Product.where(integrated: true).count
    }
  end