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

        # => include the value and the data_type from SF
        data[sf_object][sf_key] = get_field_content(sf_field.odk_fields.first, odk_data, sf_field.data_type)
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

    def get_field_content odk_field, odk_data, data_type
      return if odk_field.nil?

      # given "/first_level/second_level"
      # -> [ "first_level", "second_level", etc. ]
      field_nesting = odk_field.field_name.split("/").reject { |f| f.empty? }

      # iterate until data["first_level"]["second_level"] is reached
      value = odk_data
      field_nesting.each do |key|
        if value.kind_of?(Array)
          oldvalue = value
          value = []
          oldvalue.each do |val|
            # => Skip this record if all it's values are empty
            # => There is no need to import a completely empty record
            # => TODO: Investigate why empty records are being pulled in
            unless val.values.compact.empty?
              value << get_field_content(odk_field, val, data_type)
            end
          end
        elsif value.has_key?(key)
          value = value[key]
        end
      end
      value = transform_value(value, data_type) unless value.is_a?(Array)
      value
    end

    def transform_value(value, data_type)
      # => Transform value from ODK to data_type SF expects
      case data_type
      when "checkbox", "boolean"
        if value.nil? || value.empty? || value.eql?("No")
          value = false
        else
          value = true
        end
      when "double"
        value = value.to_f unless value.nil?
      when "phone"
        value = value.to_s
      end
      value
    end

  end
end
