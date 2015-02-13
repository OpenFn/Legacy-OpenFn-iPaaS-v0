#designsketch

class Submission::Receipt

  include Sidekiq::Worker

  def perform(raw_source_message, integration)
    submission = Submission::Record.create!(raw_source_message: raw_source_message, integration: integration)
    
    Sidekiq::Client.enqueue(Submission::PayloadEncoding, submission)
  end
end