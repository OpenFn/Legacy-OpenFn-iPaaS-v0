#designsketch

class Submission::PayloadEncoding
  def initialize(submission)
    @submission = submission
  end

  def work
    source_message = Integration::__ProductModule__.encode(submission.raw_source_message)
    submission.source_message = source_message
    submission.save!
    
    Resque.enqueue Submission::Translation.new(submission)
  end
end