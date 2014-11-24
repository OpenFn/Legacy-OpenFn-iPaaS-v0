class Submission::Receipt
  def initialize(source_payload, integration)
    @source_payload = source_payload
    @integration = integration
  end

  def work
    submission = Submission::Record.create!(source_payload: @source_payload, integration: @integration)
    
    Resque.enqueue Submission::Translation.new(submission)
  end
end