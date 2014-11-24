#designsketch

class Submission::PayloadDecoding

  def initialize(submission)
    @submission = submission
  end

  def queue
    :pipeline_payload_decoding
  end

  def work
    @submission.raw_destination_payload = integration_klass.decode(@submission.destination_payload)
    @submission.save!
    
    # only for PUSH destination integrations. Pulls can be handled by storing destination payloads for collection.
    Resque.enqueue Submission::Dispatch.new(@submission)
  end

  private
  def integration_klass
    Integration.const_get(@submission.integration.destination.integration_type)
  end
end