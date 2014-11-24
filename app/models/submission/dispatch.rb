#designsketch

class Submission::Dispatch
  
  def initialize(submission)
    @submission = submission
  end

  def work
    Integration::__ProductModule__.submit(
      submission.destination_payload,
      submission.integration.destination_credential
    )
  end
end
