require 'rails_helper'

RSpec.describe Submission::Record, :type => :model do

  it { should belong_to :mapping }
  
  it { should validate_presence_of :mapping_id }
  it { should validate_presence_of :raw_source_payload }

  context "raw_source_payload" do
   
    let(:obj_payload) { {a: 1, b: 2} }
    subject { Submission::Record.new(raw_source_payload: obj_payload) }

    it "attempts to marshall objects into json" do
      expect(subject.raw_source_payload).to eql obj_payload.to_json
    end
  end

end
