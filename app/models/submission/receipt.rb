class Submission::Receipt
  attr_reader :payload, :integration

  def initialize(payload, integration)
    
  end

  def work
    # Place the right thing on the Translation queue
  end
end