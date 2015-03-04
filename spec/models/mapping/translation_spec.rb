require 'rails_helper'

# TODO: move this into spec helper
def with_mapping(*pairs)
  let(:field_mappings) {
    pairs.collect {|p| p.map { |source,destination| 
        FieldMapping.new(source_field: source, destination_field: destination) 
    }}.flatten 
  }
end

RSpec.describe Mapping::Translation do


  subject { Mapping::Translation.new(payload, field_mappings).result }

  context "single source objects" do

    context "without children" do
      
      let(:payload) { {
        "source" => {
          "first_name" => "taytay",
          "last_name" => "downs",
          "number" => 12345,
          "custom_field" => "----",
          "contact_name" => "alfred"
        } 
      } }

      context "single destination object" do
        with_mapping(
          { "source/first_name" => "object/name" },
          { "source/number" => "object/clientID" }
        )

        it { is_expected.to eql(
          { "object" => [ {"name" => "taytay", "clientID" => 12345} ] }
        ) }
      end
      context "split destination objects" do

        # Doesn't work at the moment, because the same keys exist in different
        # destination paths.
        #
        # i.e. 
        #   object => name
        #   object => name
        # v.s.
        #   object => name,name
        #
        # We would need a way to decorate the same distination object so the
        # deep_merge doesn't assume they are the same.

        with_mapping(
          { "source/first_name" => "contact/name" },
          { "source/number" => "contact/number" },
        )

        it { is_expected.to eql(
          { "contact" => [ {"name" => "taytay"}, {"name" => "alfred"} ] }
        ) }
        
      end

    end

    context "with children" do

      let(:payload) { {
        "source" => [{
            "name" => "taytay",
            "number" => 12345,
            "custom_field" => "----",
            "skip_me" => true
          }, {
            "name" => "stu",
            "number" => 67891,
            "custom_field" => "----",
            "skip_me" => true
          } ] 
      } }
      
      context "single destination object" do
        with_mapping(
          { "source/name" => "object/name" },
          { "source/number" => "object/clientID" },
          { "source/custom_field" => "object/customField" },
        )

        it { is_expected.to eql({ 
          "object" => [ 
            {"name" => "taytay", "clientID" => 12345, "customField" => "----"},
            {"name" => "stu", "clientID" => 67891, "customField" => "----"}
          ]
        }) }
      end

      context "multiple destination objects" do
        with_mapping(
          { "source/name" => "object/name" },
          { "source/number" => "object/clientID" },
          { "source/custom_field" => "object/customField" },

          { "source/custom_field" => "custom/note" },
          { "source/number" => "custom/number" }
        )

        it { is_expected.to eql({ 
          "object" => [ 
            {"name" => "taytay", "clientID" => 12345, "customField" => "----"},
            {"name" => "stu", "clientID" => 67891, "customField" => "----"}
          ],
          "custom" => [
            {"number" => 12345, "note" => "----"},
            {"number" => 67891, "note" => "----"}
          ]
        }) }
        
      end

    end

    context "with nested children" do

      let(:payload) { {
        "customer" => {
          "name" => "taytay",
          "number" => 12345,
          "custom_field" => "----",
          "skip_me" => true,
          "sales" => [{
            "amount" => 123.00,
            "sold_on" => "24-02-15"
          },{
            "amount" => 456.00,
            "sold_on" => "24-02-15"
          }]
        } 
      } }
      
      context "single destination object" do
        # is this even possible?
        
      end
      context "multiple destination objects" do
        
      end

    end

  end

  context "multiple source objects" do
    
  end

  context "single source object" do

    context "with multiple destination fields" do

      let(:payload) { {
        "source" => {
          "name" => "taytay",
          "number" => 12345,
          "custom_field" => "----"
        } 
      } }

      with_mapping(
        { "source/name" => "object/name" },
        { "source/number" => "object/clientID" }
      )

      it { is_expected.to eql({ 
        "object" => [ {"name" => "taytay", "clientID" => 12345} ] 
      }) }
      
    end

    context "with children" do
      
      let(:payload) { {
        "source" => [{
            "name" => "taytay",
            "number" => 12345,
            "custom_field" => "----",
            "skip_me" => true
          }, {
            "name" => "stu",
            "number" => 67891,
            "custom_field" => "----",
            "skip_me" => true
          } ] 
      } }

      with_mapping(
        { "source/name" => "object/name" },
        { "source/number" => "object/clientID" },
        { "source/custom_field" => "object/customField" }
      )

      it { is_expected.to eql({ 
        "object" => [ 
          {"name" => "taytay", "clientID" => 12345, "customField" => "----"},
          {"name" => "stu", "clientID" => 67891, "customField" => "----"}
        ]
      }) }

    end

    context "with multiple destination objects" do

    end
    
  end


  context "nested multiple source objects" do
    # pending.
  end

  context "multiple root" do
    
  end


end

