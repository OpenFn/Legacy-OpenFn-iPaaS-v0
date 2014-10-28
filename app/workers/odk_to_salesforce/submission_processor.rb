module OdkToSalesforce
  class SubmissionProcessor

    @queue = :submission_processor

    def self.perform(mapping_id, submission_id)
      new(mapping_id, submission_id).perform
    end

    def initialize(mapping_id, submission_id)
      @mapping = Mapping.find(mapping_id)
      @submission = @mapping.import.submissions.find(submission_id)
      @converter = OdkToSalesforce::Converter.new
      @restforce_connection = RestforceService.new(@mapping.user).connection
      @all_import_objects = []
    end

    def perform

      begin
        process_submission
        @submission.message = nil
        @submission.backtrace = nil
        @submission.successful
      rescue Exception => e
        puts "An error occurred"

        # => Destroy all objects that were created before this error
        # => If the record already existed before this import, leave it!
        @all_import_objects.each do |io|
          puts "Deleting #{io.object_name}: #{io.id}"
          io.destroy if io.new_record
        end

        @submission.message = e.message
        @submission.backtrace = e.backtrace.first(15).join('<br />')
        @submission.failed
      end
    end

    protected

    def process_submission
      # => Mark this submission as being processed, for the first time or
      @submission.process

      salesforce_objects = @mapping.salesforce_objects

      # => Loop through each SalesforceObject in the mapping
      salesforce_objects.each do |salesforce_object|

        # => Load the fields for the salesforce_object
        salesforce_fields = salesforce_object.salesforce_fields.joins(:odk_fields)

        # => If the object is a repeat, then create multiples of them
        if salesforce_object.is_repeat

          # => Load the node in the odk_data that contains all these repeat fields
          repeat_odk_data = @converter.get_repeat_field_root(salesforce_fields.first.odk_fields.first, @submission.data)

          repeat_odk_data.each_with_index do |rod, i|
            create_in_salesforce(salesforce_object, salesforce_fields, rod, i)
          end
        else
          create_in_salesforce(salesforce_object, salesforce_fields, @submission.data)
        end
      end
    end

    def create_in_salesforce(salesforce_object, salesforce_fields, submission_data, index = 1)
      # => Create multiple of these objects

      import_object = OdkToSalesforce::SalesforceObjects::ImportObject.new(@restforce_connection, salesforce_object)

      salesforce_fields.each do |salesforce_field|

        # => TODO: concatenate multiple fields
        odk_field = salesforce_field.odk_fields.first

        odk_field_value = @converter.get_field_content(odk_field, submission_data)
        odk_field_value = transform_uuid_value(odk_field_value, salesforce_object, index) if odk_field.is_uuid

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

    def transform_uuid_value(uuid, salesforce_object, index)
      if salesforce_object.is_repeat
        return "#{uuid}/#{salesforce_object.order}r/#{index + 1}"
      else
        return "#{uuid}/#{salesforce_object.order}"
      end
    end
  end
end