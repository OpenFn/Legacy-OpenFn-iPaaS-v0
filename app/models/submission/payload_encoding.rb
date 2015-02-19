#designsketch

class Submission::PayloadEncoding

  include Sidekiq::Worker
  
  def perform(submission)
    submission.source_payload = integration_klass.encode(submission.raw_source_payload)
    submission.save!
    
    Sidekiq::Client.enqueue(Submission::Translation, submission)
  end

  private
  def integration_klass
    Integration.const_get(submission.integration.source.integration_type)
  end
end
