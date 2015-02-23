require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!


require 'openfn_odk/openfn_odk'

RSpec.describe "ODK Pipeline", :type => :integration do

  # Currently the Odk::Aggregate gem returns a hash.
  # In lieu of changing this, hashes get marshalled into JSON.
  let(:odk_submission) {
    {"xmlns"=>"http://opendatakit.org/submissions",
     "xmlns:orx"=>"http://openrosa.org/xforms",
     "data"=>
     {"event_cars_boats"=>
      {"id"=>"Events_Boats_Cars",
       "instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084",
       "submissionDate"=>"2014-11-11T08:04:40.178Z",
       "isComplete"=>"true",
       "markedAsCompleteDate"=>"2014-11-11T08:04:40.178Z",
       "event_name"=>"Catalina wine mixer",
       "start_date"=>"2014-11-11",
       "boats"=>[{"boat_name"=>"Big boat"}, {"boat_name"=>"Catamaran"}, {"boat_name"=>"Catatafish"}],
       "cars"=>{"car_name"=>"Peugeot"},
       "meta"=>{"instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084"}}}}
  }

  let(:product) { Product.create!(name: "ODK", integration_type: "Odk") }

  let(:mapping) { Mapping.create!(
    source_app: source_app
  ) }

  let(:source_app) { ConnectedApp.create(product: product) }

  it "should translate the ODK payload, and persist it on Submission::Record" do

    Submission::Receipt.perform_async(odk_submission,mapping.id)
    record = Submission::Record.first
    expect(record.raw_source_payload).to eql(odk_submission.to_json)
    
  end
end
