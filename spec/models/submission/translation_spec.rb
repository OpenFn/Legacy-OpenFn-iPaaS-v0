require 'rails_helper'

RSpec.describe Submission::Translation, :type => :model do

  let(:record) { double(Submission::Record, {
    id: 10, 
    mapping: double(Mapping),
    source_payload: "source payload!"
  }) }

  let(:translation) { double(Mapping::Translation, result: "result!") }

  subject { Submission::Translation.new.perform(record.id) }

  before :each do
    allow(Submission::Record).to receive(:find).with(10).and_return record
    allow(record).to receive(:destination_payload=)
    allow(record).to receive(:save!)
    allow(Sidekiq::Client).to receive(:enqueue)
    allow(Mapping::Translation).to receive(:new).and_return translation
  end

  it "finds the record" do
    expect(Submission::Record).to receive(:find).with(10)
    subject
  end

  it "translates the source_payload and saves it as the destination_payload" do
    expect(Mapping::Translation).to receive(:new).
      with(record.source_payload, record.mapping).
      and_return translation
    expect(record).to receive(:destination_payload=).with translation.result
    expect(record).to receive(:save!)
    subject
  end

  it "queues up the payload decoder" do
    expect(Sidekiq::Client).to receive(:enqueue).
      with(Submission::PayloadDecoding, record.id)
    subject
  end
end
