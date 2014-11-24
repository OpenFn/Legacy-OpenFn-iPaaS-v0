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

    let(:odk_form) { OdkForm.new(name: "Test ODKForm") }
    let(:mapping) { Mapping.create!(name: "Test", odk_form: odk_form) }


    before(:each) do
      odk_form.stub(populate_fields: true)
      salesforce_object.stub(create_fields_from_salesforce: true)
      salesforce_object.save!
    end

    let(:submission_data) { {
      
      "id"=>"Events_Boats_Cars",
      "instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084",
      "submissionDate"=>"2014-11-11T08:04:40.178Z",
      "isComplete"=>"true",
      "markedAsCompleteDate"=>"2014-11-11T08:04:40.178Z",
      "event_name"=>"Catalina wine mixer",
      "start_date"=>"2014-11-11",
      "methods"=>"hello!",
      "boats"=>[{"boat_name"=>"Big boat"}, {"boat_name"=>"Catamaran"}, {"boat_name"=>"Catatafish"}],
      "cars"=>{"car_name"=>"Peugeot"},
      "meta"=>{"instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084"}

    } } 

    subject { OdkToSalesforce::Converter.new }

    context "without repeat fields" do

      let(:salesforce_fields) { 
        [
          {
            "field_name"=>"vera__ODK_Key__c",
            "data_type"=>"string",
            odk_fields: [ OdkField.new(
              {
                "field_name"=>"/meta/instanceID",
                "field_type"=>"string",
                "is_uuid"=>true,
                "uuidable"=>true,
                "repeat_field"=>nil
              }
            ) ]
          },
          {
            "field_name"=>"vera__Start_Date__c",
            "data_type"=>"date",
            odk_fields: [ OdkField.new(
              {
                "field_name"=>"/start_date",
                "field_type"=>"date",
                "salesforce_field_id"=>nil,
                "is_uuid"=>false,
                "uuidable"=>false,
                "repeat_field"=>false
              }
            ) ]
          },
          {
            "field_name"=>"vera__Test_Event_Name_Unique__c",
            "data_type"=>"string",
            odk_fields: [ OdkField.new(
              {
                "field_name"=>"/event_name",
                "field_type"=>"string",
                "salesforce_field_id"=>nil,
                "is_uuid"=>false,
                "uuidable"=>false,
                "repeat_field"=>false
              }
            ) ]
          }
        ].collect { |attrs| SalesforceField.new(attrs) } 
      }

      let(:salesforce_object) { 
        SalesforceObject.new({
          "name"=>"vera__Test_Event__c",
          "order"=>1,
          "is_repeat"=>false,
          mapping: mapping,
          salesforce_fields: salesforce_fields
        }) 
      }

      it "returns a hash of mapped odk data" do
        expect(subject.odk_data(salesforce_object, submission_data)).to eql [ {
          "meta"=>{"instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084"},
          "start_date"=>"2014-11-11",
          "event_name"=>"Catalina wine mixer"
        } ]
      end

    end
    context "with repeat fields" do

      let(:salesforce_fields) { 
        [
          {
            "field_name"=>"Name",
            "data_type"=>"string",
            odk_fields: [ OdkField.new(
              {
                "field_name"=>"/boats/boat_name",
                "field_type"=>"string",
                "odk_form_id"=>54,
                "repeat_field"=>true
              }
            ) ]
          },
          {
            "field_name"=>"vera__Boat_Maker__c",
            "data_type"=>"string",
            odk_fields: [ OdkField.new(
              {
                "field_name"=>"/boats/boat_name",
                "field_type"=>"string",
                "odk_form_id"=>54,
                "repeat_field"=>true
              }
            ) ]
          },
          {
            "field_name"=>"vera__odk_key__c",
            "data_type"=>"string",
            odk_fields: [ OdkField.new(
              {
                "field_name"=>"/meta/instanceID",
                "field_type"=>"string",
                "odk_form_id"=>54,
                "is_uuid"=>true,
                "uuidable"=>true,
                "repeat_field"=>nil
              }
            ) ]
          },
          {
            "field_name"=>"Methods_Used_Score__c",
            "data_type"=>"string",
            odk_fields: [ OdkField.new(
              {
                "field_name"=>"/methods",
                "field_type"=>"string",
                "odk_form_id"=>54,
                "repeat_field"=>nil
              }
            ) ]
          }
        ].collect { |attrs| SalesforceField.new(attrs) } 
      }

      let(:salesforce_object) { 
        SalesforceObject.new({
          "name"=>"vera__Boat__c",
          "order"=>1,
          "is_repeat"=>true,
          mapping: mapping,
          salesforce_fields: salesforce_fields
        }) 
      }

      it "returns a hash of mapped odk data" do
        expect(subject.odk_data(salesforce_object, submission_data)).to eql [ 
          {
            "boat_name"=>"Big boat",
            "meta"=>{"instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084"},
            "methods"=>"hello!"
          },
          {
            "boat_name"=>"Catamaran",
            "meta"=>{"instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084"},
            "methods"=>"hello!"
          },
          { 
            "boat_name"=>"Catatafish",
            "meta"=>{"instanceID"=>"uuid:76e2641d-6d6b-4f15-9758-91ec246ff084"},
            "methods"=>"hello!"
          }
        ]
      end
      
    end

  end


end
