# Submission Payload Encoding
# ===========================

# Translates a raw payload from an integration to a generic data format.

class Submission::PayloadEncoding

  include Sidekiq::Worker
  
  def perform(record_id)
    record = Submission::Record.find(record_id)
    integration_klass = integration_klass_for(record)

    # Once a submission has been received, we request the integration class
    # to encode it's payload structure into a generic one.
    record.source_payload = integration_klass.encode(record.raw_source_payload)
    record.save!
    
    # Queue up the submission for translating.
    Sidekiq::Client.enqueue(Submission::Translation, record.id)
  end

  private
  def integration_klass_for(record)
    OpenFn.const_get(record.mapping.source_app.product.integration_type)
  end
end
