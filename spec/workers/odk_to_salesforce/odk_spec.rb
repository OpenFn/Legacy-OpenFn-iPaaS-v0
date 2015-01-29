require 'spec_helper'

RSpec.describe OdkToSalesforce::Odk do
  let(:connection) { double(OdkAggregate::Connection) }
  let(:data) { "good stuff"}
  let(:media_data) { [{}, {}]}
  let(:form) { {topElement: "abc", id: 9999} }
  let(:submission_response) { {"submission" => {"data" => {"lots of" => data}, "mediaFile" => media_data}}}
  let(:uuid) { "uuid:123" }
  # Don't try this at home kids! A hack to make initialising the class less labour-intensive
  # When we add specs for the initialize mthod, this landmine must go away!
  class OdkToSalesforce::Odk
    def initialize(connection, form)
      @connection = connection
      @form = form
    end
  end
  subject { described_class.new(connection, form) }
  it "fetches the submission data" do
    expect(connection).to receive(:submissions_where).with(formId: form[:id], key: uuid, topElement: form[:topElement]).
      and_return(submission_response)

    subject.fetch_submission(uuid)
  end

  it "returns the parsed submission data" do
    allow(connection).to receive(:submissions_where).and_return(submission_response)

    expect(subject.fetch_submission(uuid)).to eql submission_response["submission"]
  end
end
