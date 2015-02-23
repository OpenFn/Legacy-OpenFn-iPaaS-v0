# Submission Receipt
# ==================

# Receives a raw payload from a given integration

# Creates a new [Submission::Record](record.rb) with the raw payload,
# and the integration associated.

# Enqueues the submission to be encoded in the generic data format via
# [Submission::PayloadEncoding](payload_encoding.rb)

class Submission::Receipt

  include Sidekiq::Worker

  def perform(raw_source_payload,mapping_id)
    record = Submission::Record.create!({
      raw_source_payload: raw_source_payload, 
      mapping_id: mapping_id
    })

    Sidekiq::Client.enqueue(Submission::PayloadEncoding, record.id)
  end
end
