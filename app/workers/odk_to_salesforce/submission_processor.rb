module OdkToSalesforce
  class SubmissionProcessor

    def self.perform(submission_data, mapping)
      new(mapping).perform(submission_data)
    end

    def initialize(mapping)
      @mapping = mapping
      @converter = OdkToSalesforce::Converter.new
      @restforce_connection = RestforceService.new(@mapping.user).connection
      @all_import_objects = []
    end

    def perform(submission_data)
      salesforce_objects = @mapping.salesforce_objects.order(:order)

      # => Loop through each SalesforceObject in the mapping
      salesforce_objects.each do |salesforce_object|

        # => Load the fields for the salesforce_object
        salesforce_fields = salesforce_object.salesforce_fields.joins(:odk_fields)

        # => If the object is a repeat, then create multiples of them
        if salesforce_object.is_repeat

          # => Load the node in the odk_data that contains all these repeat fields
          repeat_odk_data = @converter.get_repeat_field_root(salesforce_fields.first.odk_fields.first, submission_data)

          repeat_odk_data.each do |rod|
            create_in_salesforce(salesforce_object, salesforce_fields, rod)
          end
        else
          create_in_salesforce(salesforce_object, salesforce_fields, submission_data)
        end
      end
    end

    protected

    def create_in_salesforce(salesforce_object, salesforce_fields, submission_data)
      # => Create multiple of these objects

      import_object = OdkToSalesforce::SalesforceObjects::ImportObject.new(@restforce_connection, salesforce_object)

      salesforce_fields.each do |salesforce_field|

        # => TODO: concatenate multiple fields
        odk_field = salesforce_field.odk_fields.first

        odk_field_value = @converter.get_field_content(odk_field, submission_data)

        if salesforce_field.data_type == "reference"
          # => This is a lookup field
          import_object.populate_lookup_field(salesforce_field, odk_field_value)
        else
          # => Process the regular field
          import_object.attributes[salesforce_field.field_name] = odk_field_value
        end
      end

      import_object.populate_relationships(@all_import_objects)

      if import_object.save
        @all_import_objects << import_object
      end
    end

  end
end