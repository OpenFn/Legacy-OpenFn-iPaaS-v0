#designsketch

class Submission::Translation

  include Sidekiq::Worker
  
  def perform(record)
    translation = Mapping::Translation.new(record.source_payload, record.integration.mappings)
    record.destination_payload = translation.result
    record.save!
    
    Sidekiq::Client.enqueue(Submission::PayloadDecoding, record)
  end
end
