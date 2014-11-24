#designsketch

class Submission::Receipt
  def initialize(raw_source_message, integration)
    @raw_source_message = raw_source_message
    @integration = integration
  end

  def work
    submission = Submission::Record.create!(raw_source_message: @raw_source_message, integration: @integration)
    
    Resque.enqueue Submission::PayloadEncoding.new(submission)
  end
end