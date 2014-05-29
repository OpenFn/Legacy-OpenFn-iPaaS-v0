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
        sf_object = sf_field.object_name.to_sym
        sf_key = sf_field.field_name.to_sym
        data[sf_object] = {} unless data.has_key? sf_object
        data[sf_object][sf_key] = get_field_content(sf_field.odk_fields.first,
                                                    odk_data)
      end

      data
    end

    private

    def get_field_content odk_field, odk_data
      # given "/first_level/second_level"
      # -> [ "first_level", "second_level", etc. ]
      field_nesting = odk_field.field_name.split("/").reject { |f| f.empty? }

      # iterate until data["first_level"]["second_level"] is reached
      value = odk_data
      field_nesting.each do |key|
        value = value[key]
      end
      value
    end

  end
end
