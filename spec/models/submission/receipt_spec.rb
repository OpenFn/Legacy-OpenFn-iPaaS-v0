require 'rails_helper'

RSpec.describe Submission::Receipt, :type => :model do

  let(:message) { "<an> <xml> string </xml> </an>" }
  let(:mapping) { double(Mapping, id: 5) }
  let(:record) { double(Submission::Record, id: 10) }

  subject { Submission::Receipt.new }

  describe "responsibilities" do
    it "creates a submission record" do
      expect(Submission::Record).to receive(:create!).
        with(raw_source_payload: message, mapping_id: mapping.id).
        and_return(record)

      expect(Sidekiq::Client).to receive(:enqueue).
        with(Submission::PayloadEncoding, record.id).and_return(nil)

      subject.perform(message, mapping.id)
    end
  end

end
