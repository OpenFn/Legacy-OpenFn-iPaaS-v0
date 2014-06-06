module OdkToSalesforce
  ##
  # Convert an ODK data hash into a sailiasforce hash from a mapping
  #
  # odk_form -> { sf_object: { sf_field: "value" } }
  class Converter

    def initialize mapping
      @mapping = mapping
    end

    def convert odk_data
      data = {}

      @mapping.salesforce_fields.each do |sf_field|
        sf_object = "#{sf_field.object_name.gsub(" ", "_")}__c".to_sym
        sf_key = sf_field.field_name.to_sym
        data[sf_object] = {} unless data.has_key? sf_object
        data[sf_object][sf_key] = get_field_content(sf_field.odk_fields.first,
                                                    odk_data)
      end

      # NOTE: temporarty hackity hack hack
      data = append_staff_member_type_id(data)

      data
    end

    private

    # temporaryly hardcode all staff members as HQ Staff while issue is
    # being sorted out.
    def append_staff_member_type_id(data)
      if data.has_key?(:staff_member__c)
        data[:staff_member__c][:RecordTypeId] = "01290000000hbFGAAY"
      end
      data
    end

    def get_field_content odk_field, odk_data
      # given "/first_level/second_level"
      # -> [ "first_level", "second_level", etc. ]
      field_nesting = odk_field.field_name.split("/").reject { |f| f.empty? }

      # iterate until data["first_level"]["second_level"] is reached
      value = odk_data
      field_nesting.each do |key|
        if value.nil?
          # do nothing
        elsif value.kind_of?(Array)
          oldvalue = value
          value = []
          oldvalue.each do |val|
            value << get_field_content(odk_field, val)
          end
        elsif value.has_key?(key)
          value = value[key]
        end
      end
      value
    end

  end
end
