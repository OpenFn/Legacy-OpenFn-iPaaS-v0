class WelcomeStatsController < ApplicationController

  def show
    render json: {
      #code submissionCount + 35,605 for KGVK's pre-reset submissions
      submissionCount: Submission.where(state: 'success').count + 35605,
      orgCount: User.where(role: 'client').count,
      productPublicCount: Product.where(enabled: true).count,
      productConnectedCount: Product.where(integrated: true).count
    }
  end

end