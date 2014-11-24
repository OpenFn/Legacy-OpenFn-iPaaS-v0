class Submission::Translation
  def initialize(submission)
    @submission = submission
  end

  def work
    translation = Mapping::Translation.for(submission.source_payload, submission.integration.mappings)
    submission.destination_payload = translation.result
    submission.save!
    
    Resque.enqueue Submission::Dispatch.new(submission)
  end
end