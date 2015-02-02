module OdkToSalesforce
  ##
  # Convert an ODK data hash into a salesforce hash from a mapping
  #
  # odk_form -> { sf_object: { sf_field: "value" } }
  class Converter

    def odk_data(salesforce_object, odk_data)
      arr = []

      # => Load all the fields that are a repeat
      repeat_odk_fields = repeat_odk_fields_for(salesforce_object)   
      non_repeat_odk_fields = non_repeat_odk_fields_for(salesforce_object)

      # => Check if the salesforce object is a repeat
      if salesforce_object.is_repeat

        # => Get the first repeat field to extract it's key
        odk_field = repeat_odk_fields.first

        # => Extract the key.  ["repeat_block", "repeat_field"]
        field_nesting = odk_field.field_name.split("/").reject!(&:empty?)

        # => Load the repeat object
        repeat = field_nesting[0...-1].reduce(odk_data) { |memo,key| memo[key] }

        [repeat].reject(&:nil?).flatten.each do |repeat_hash|
          non_repeat_odk_fields.each do |non_r_field|
            # => Merge the other field values

            key = non_r_field.field_name.split("/").reject { |f| f.empty? }.first
            repeat_hash.merge!(key => odk_data[key])
          end

          arr << repeat_hash
        end
      else
        # => This object is not part of a repeat block
        # => Lets just iterate through the non repeat sections and populate the values
        hsh = {}
        non_repeat_odk_fields.each do |non_r_field|
          # => Merge the other field values
          key = non_r_field.field_name.split("/").reject!(&:empty?).first
          hsh.merge!(key => odk_data[key])
        end

        arr << hsh
      end

      arr
    end
    
    # Wedge between #odk_data and the odk fields, allows for stubbing during
    # tests.
    def repeat_odk_fields_for(salesforce_object)
      salesforce_object.salesforce_fields.joins(:odk_fields).
        merge(OdkField.repeat_fields).includes(:odk_fields).collect(&:odk_fields).flatten.uniq
    end

    def non_repeat_odk_fields_for(salesforce_object)
      salesforce_object.salesforce_fields.joins(:odk_fields).
        merge(OdkField.non_repeat_fields).includes(:odk_fields).collect(&:odk_fields).flatten.uniq
    end

    # ===================

    def get_field_content(odk_field, odk_data)

      # given "/first_level/second_level"
      # -> [ "first_level", "second_level", etc. ]

      struct = Hashie::Mash.new(odk_data)
      path = odk_field.field_name.split("/").reject!(&:blank?)

      if odk_field.repeat_field
        value = struct[path.last]
      else
        # Find the value of the field using the path
        value = path.reduce(struct) { |memo,key| memo[key] }
      end

      value = transform_value(value, odk_field.field_type) unless value.is_a?(Array)
      value
    end

    private

    def transform_value(value, type)
      # => Transform value from ODK to type SF expects
      case type
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
