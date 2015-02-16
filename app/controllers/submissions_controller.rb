class SubmissionsController < ApplicationController

  before_action :load_mapping
  before_action :load_submission, only: [:show, :reprocess]

  def index
    @mapping = current_user.mappings.find params[:mapping_id]
    @submissions = @mapping.import.submissions
    @submissions = @submissions.where(state: params[:state]) unless params[:state].blank?
  end

  def reprocess
    Sidekiq::Client.enqueue(OdkToSalesforce::SubmissionProcessor, @mapping.id, @submission.id)
    redirect_to :back
  end

  def count
    render json: {
      count: Submission.where(state: 'success').count + 35000
      #hard code a plus 35k for KGVK's pre-changeover submissions
    }
  end

  protected

  def load_mapping
    @mapping = current_user.mappings.find params[:mapping_id]
  end

  def load_submission
    @submission = @mapping.import.submissions.find params[:id]
  end

end
