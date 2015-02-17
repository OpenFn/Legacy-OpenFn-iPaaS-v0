class WelcomeStatsController < ApplicationController

skip_before_filter :require_login

  def show
    render json: {
      #We add 35,605 to submissionCount for KGVK's pre-reset submissions
      submissionCount: Submission.where(state: 'success').count + 35605,
      orgCount: User.where(role: 'client').count,
      productPublicCount: Product.where(enabled: true).count,
      productConnectedCount: Product.where(integrated: true).count
    }
  end

end