#designsketch

class Submission::Translation

  include Sidekiq::Worker
  
  def perform(record_id)
    record = Submission::Record.find(record_id)
    translation = Mapping::Translation.new(record.source_payload, record.mapping_id)
    record.destination_payload = translation.result
    record.save!
    
    Sidekiq::Client.enqueue(Submission::PayloadDecoding, record.id)
  end
end
