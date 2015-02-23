#designsketch

class Submission::PayloadDecoding

  include Sidekiq::Worker

  def perform(record_id)
    record = Submission::Record.find(record_id)
    record.raw_destination_payload = integration_klass_for(record).
      decode(record.destination_payload)
    record.save!
    
    # only for PUSH destination integrations. Pulls can be handled by storing destination payloads for collection.
    Sidekiq::Client.enqueue(Submission::Dispatch, record.id)
  end

  private
  def integration_klass_for(record)
    OpenFn.const_get(record.mapping.destination_app.product.integration_type)
  end
end
