#designsketch

class Submission::PayloadEncoding
  
  def initialize(submission)
    @submission = submission
  end

  def queue
    :pipeline_payload_encoding
  end

  def work
    @submission.source_payload = integration_klass.encode(@submission.raw_source_payload)
    @submission.save!
    
    Resque.enqueue Submission::Translation.new(@submission)
  end

  private
  def integration_klass
    Integration.const_get(@submission.integration.source.integration_type)
  end
end