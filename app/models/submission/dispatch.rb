#designsketch

class Submission::Dispatch
  
  def initialize(submission)
    @submission = submission
  end

  def queue
    :pipeline_dispatch
  end

  def work
    integration_klass.submit!(@submission.raw_destination_payload, @submission.integration.destination_credentials)
    @submission.submitted!
  end

  private
  def integration_klass
    Integration.const_get(@submission.integration.destination.integration_type)
  end
end
