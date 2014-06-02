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
      odk_data = make_every_value_array!(odk_data)

      @mapping.salesforce_fields.each do |sf_field|
        sf_object = sf_field.object_name.to_sym
        sf_key = sf_field.field_name.to_sym

        data[sf_object] = [] unless data[sf_object].kind_of?(Array)
        #data[sf_object] = {} unless data.has_key? sf_object

     #  data[sf_object] << {}[sf_key] = get_field_content(
     #                                    sf_field.odk_fields.first,
     #                                    odk_data)
       field_nesting = sf_field.odk_fields.first.field_name.split('/').reject { |f| f.empty? }
       
       odk_field_iterator(field_nesting, odk_data, data[sf_object])

      end

      data
    end

    private

    # iterate until data["first_level"]["second_level"] is reached
    # # generate array of values [value, value, value]
    def odk_field_iterator(field_nesting, odk_data, arr)
      odk_data_subset = odk_data
      puts "=== #{odk_data_subset[field_nesting[0]]}"
      odk_data_subset[field_nesting[0]].each do |value|
        if value.kind_of?(Hash)
          odk_field_iterator(field_nesting.drop(1), value, arr)
        else
          puts value
          arr << value
        end
      end
    end

    ##
    # We turn every object of the form
    #
    # { field: { field: value } }
    #
    # into:
    #
    # { field: [{ field: [value] }] }
    #
    # For easier blah-bedi-blah
    def make_every_value_array!(hash)
      hash.each do |k, v|
        if v.kind_of?(Array)
          v.each { |elem| make_every_value_array!(elem) }
        elsif v.kind_of?(Hash)
          hash[k] = [make_every_value_array!(v)]
        else
          hash[k] = [v]
        end
      end
    end
  end
end
