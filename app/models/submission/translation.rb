#designsketch

class Submission::Translation

  include Sidekiq::Worker
  
  def perform(submission)
    translation = Mapping::Translation.new(submission.source_payload, submission.integration.mappings)
    submission.destination_payload = translation.result
    submission.save!
    
    Sidekiq::Client.enqueue(Submission::PayloadDecoding, submission)
  end
end
