#designsketch

class Submission::PayloadDecoding
  def initialize(submission)
    @submission = submission
  end

  def work
    raw_destination_message = Integration::__ProductModule__.decode(submission.raw_source_message)
    submission.raw_destination_message = raw_destination_message
    submission.save!
    
    Resque.enqueue Submission::Dispatch.new(submission)
  end
end