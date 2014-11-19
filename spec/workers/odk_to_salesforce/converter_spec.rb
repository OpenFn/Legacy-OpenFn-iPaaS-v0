require "rails_helper"

describe OdkToSalesforce::Converter do
  
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

end
