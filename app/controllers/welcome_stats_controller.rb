class WelcomeStatsController < ApplicationController

skip_before_filter :require_login

  def show
    render json: {
      #KGVK: We add 35,605 to submissionCount for KGVK's "pre-reset" submissions.
      #MyAgro: Installed OpenFn on their SF instance on 12/23/14.
      #MyAgro (cont.): We add 96,001 (as of 9/14/15) for their SMS transactions since installing.
      submissionCount: OdkSfLegacy::Submission.where(state: 'success').count + 35605 + 96001,
      orgCount: User.distinct.count('organisation'),
      productPublicCount: Product.where(enabled: true).count,
      productConnectedCount: Product.where(integrated: true).count
    }
  end

end
