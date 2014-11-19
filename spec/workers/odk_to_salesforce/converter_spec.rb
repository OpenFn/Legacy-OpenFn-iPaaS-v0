require "rails_helper"

describe OdkToSalesforce::Converter do
  
  describe "#get_field_content" do

    subject { OdkToSalesforce::Converter.new.get_field_content(field,data) }

    context "odk data with a 'class' key" do
      let(:data) {
        {
          "id"=>"School_Attendance",
          "instanceID"=>"uuid:776960f0-732c-4085-96dc-642330a712bc",
          "submissionDate"=>"2014-11-17T20:46:19.000Z",
          "isComplete"=>"true",
          "markedAsCompleteDate"=>"2014-11-17T20:46:19.000Z",
          "school_id"=>"SCH-0058",
          "date"=>"2014-11-25",
          "holiday"=>"yes",
          "class"=>"p1",
          "teacher_id"=>"STA-100",
          "status"=>"absent",
          "num_enrolled"=>"8",
          "num_present"=>"6",
          "num_absent"=>"2",
          "meta"=>{"instanceID"=>"uuid:776960f0-732c-4085-96dc-642330a712bc"}
        }
      }

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

end
