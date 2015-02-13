#designsketch

class Submission::PayloadDecoding

  include Sidekiq::Worker

  def perform(submission)
    submission.raw_destination_payload = integration_klass.decode(submission.destination_payload)
    submission.save!
    
    # only for PUSH destination integrations. Pulls can be handled by storing destination payloads for collection.
    Sidekiq::Client.enqueue(Submission::Dispatch, submission)
  end

  private
  def integration_klass
    Integration.const_get(submission.integration.destination.integration_type)
  end
end