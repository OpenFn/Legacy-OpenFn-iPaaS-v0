require "rails_helper"

RSpec.describe OdkToSalesforce::Converter do
  
  describe "#get_field_content" do

    subject { OdkToSalesforce::Converter.new.get_field_content(field,data) }

    context "odk data with a 'class' key" do
      let(:data) { { "class"=>"p1" } }

      let(:field) {  
        OdkField.new({
          "field_name"=>"/class",
          "field_type"=>"string",
          "salesforce_field_id"=>nil,
          "odk_form_id"=>83,
          "is_uuid"=>true,
          "uuidable"=>true,
          "repeat_field"=>nil
        })
      }

      it { should eql "p1" }
    end
  end

  describe "#odk_data" do

    fixtures :salesforce_objects
    fixtures :salesforce_fields
    fixtures :odk_fields
    fixtures :odk_field_salesforce_fields

    let(:converter) { OdkToSalesforce::Converter.new }

    subject { converter.odk_data(salesforce_object, submission_data) }

    let(:submission_data) { {
      
      "id"=>"Events_Boats_Cars",
      "instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084",
      "submissionDate"=>"2014-11-11T08:04:40.178Z",
      "isComplete"=>"true",
      "markedAsCompleteDate"=>"2014-11-11T08:04:40.178Z",
      "event_name"=>"Catalina wine mixer",
      "start_date"=>"2014-11-11",
      "boats"=>[{"boat_name"=>"Big boat"}, {"boat_name"=>"Catamaran"}, {"boat_name"=>"Catatafish"}],
      "cars"=>{"car_name"=>"Peugeot"},
      "meta"=>{"instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084"}

    } } 

    context "TestEvent" do
      let(:salesforce_object) { SalesforceObject.find(221) }
      it { should eql [{"start_date"=>"2014-11-11", "event_name"=>"Catalina wine mixer"}] }
    end

    context "Boat" do
      let(:salesforce_object) { SalesforceObject.find(222) }
      it { should eql [
        {"boat_name"=>"Big boat"},
        {"boat_name"=>"Catamaran"},
        {"boat_name"=>"Catatafish"}
      ] }
    end

    context "Car" do
      let(:salesforce_object) { SalesforceObject.find(223) }
      it { should eql [{"car_name"=>"Peugeot"}] }
    end

  end

end
