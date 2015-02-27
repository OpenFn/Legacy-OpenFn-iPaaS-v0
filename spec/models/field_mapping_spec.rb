require 'rails_helper'

RSpec.describe FieldMapping, :type => :model do
  it { should belong_to :mapping }
  it { should validate_presence_of :mapping_id }
  it { should validate_presence_of :source_field }
  it { should validate_presence_of :destination_field }

  it { should_not allow_value('test').for(:source_field) }
  it { should_not allow_value('test').for(:destination_field) }

  it { should allow_value('test/key').for(:source_field) }
  it { should allow_value('test/key').for(:destination_field) }

  it { should allow_value('test/keys/key').for(:source_field) }
  it { should allow_value('test/keys/key').for(:destination_field) }

  describe "#mapping_for" do

    # Simple 1 level deep mapping
    subject { FieldMapping.new({ 
      source_field: "contact/name",
      destination_field: "customer/full_name"
    }).destination_payload_for(payload) }

    context "1-to-1 relationship" do

      let(:payload) { {contact: {name: 'taytay',skip_this: 1}} }
      it { should eql({"customer" => [{"full_name" => "taytay"}]}) }
      
    end

    context "1-to-many relationship" do

      let(:payload) { {contact: [{name: 'taytay'},{name: 'stu'}]} }
      it { should eql({"customer" => [{"full_name" => "taytay"},{"full_name" => "stu"}]}) }

    end
    
  end
end

