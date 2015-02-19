# Submission Receipt
# ==================

# Receives a raw payload from a given integration

# Creates a new [Submission::Record](record.rb) with the raw payload,
# and the integration associated.

# Enqueues the submission to be encoded in the generic data format via
# [Submission::PayloadEncoding](payload_encoding.rb)

class Submission::Receipt

  def initialize(raw_source_message, mapping)
    @raw_source_message = raw_source_message
    @mapping = mapping
  end

  include Sidekiq::Worker

  def perform(raw_source_message, mapping)
    record = Submission::Record.create!(raw_source_message: raw_source_message, mapping: mapping)
    
    Sidekiq::Client.enqueue(Submission::PayloadEncoding, record)
  end
end
