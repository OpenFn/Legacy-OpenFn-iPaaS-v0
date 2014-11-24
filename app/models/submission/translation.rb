class Submission::Translation
  
  def initialize(submission)
    @submission = submission
  end

  def queue
    :pipeline_translation
  end

  def work
    translation = Mapping::Translation.new(@submission.source_payload, @submission.integration.mappings)
    @submission.destination_payload = translation.result
    @submission.save!
    
    Resque.enqueue Submission::PayloadDecoding.new(@submission)
  end
end
