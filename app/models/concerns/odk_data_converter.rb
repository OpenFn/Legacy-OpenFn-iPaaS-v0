module OdkDataConverter
  extend ActiveSupport::Concern

  included do
    def set_field_content_from_odk_data(odk_data)

      # => TODO: Use concatenation on multiple fields
      odk_field_salesforce_field = self.odk_field_salesforce_fields.first
      odk_field = odk_field_salesforce_field.odk_field

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
              value << set_field_content_from_odk_data(odk_field, val, odk_field.field_type)
            end
          end
        elsif value.has_key?(key)
          value = value[key]
        end
      end
      self.import_value = transform_value(value, odk_field.field_type) unless value.is_a?(Array)
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