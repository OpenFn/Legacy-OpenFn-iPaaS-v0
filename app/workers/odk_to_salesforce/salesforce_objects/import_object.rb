module OdkToSalesforce
  module SalesforceObjects
    class ImportObject

      include QueryMethods

      attr_accessor :id, :object_name, :attributes
      attr_reader :salesforce_object, :new_record

      def initialize(rf, salesforce_object, attributes: {})
        @rf = rf
        @salesforce_object = salesforce_object
        @object_name = @salesforce_object.name
        @attributes = attributes
      end

      def populate_lookup_field(salesforce_field, odk_field_value)
        lookup_field = salesforce_field.odk_field_salesforce_fields.first.lookup_field_name || "name"
        reference_to = salesforce_field.properties["referenceTo"][0]

        puts "Finding object #{reference_to} on field #{lookup_field} with value #{odk_field_value}"
        sf_obj = @rf.query("SELECT Id FROM #{reference_to} WHERE #{lookup_field} = '#{odk_field_value}'").first
        if sf_obj
          puts "Found matching #{reference_to} for #{salesforce_field.properties["name"]}."
          @attributes[salesforce_field.properties["name"]] = sf_obj.Id
        else
          puts "No object found on #{reference_to} with #{lookup_field} == #{odk_field_value}"
        end
      end

      def populate_record_type_field(salesforce_field, odk_field_value)
        sf_obj = @rf.query("SELECT Id, Name FROM RecordType WHERE sObjectType = '#{salesforce_field.salesforce_object.name}' AND Name = '#{odk_field_value}'").first
        @attributes[salesforce_field.properties["name"]] = sf_obj.Id if sf_obj
      end

      def populate_relationships(import_objects)
        @salesforce_object.salesforce_fields.joins(:salesforce_relationship).each do |salesforce_relationship_field|
          obj = import_objects.select{|io| io.salesforce_object.id == salesforce_relationship_field.salesforce_relationship.salesforce_object.id}.first
          if obj
            @attributes[salesforce_relationship_field.field_name] = obj.id
          end
        end
      end

      def save
        puts "     creating #{@object_name} with attributes:"
        puts "              #{@attributes}"

        # => Rescue certain errors
        begin
          @id = @rf.create!(@object_name, @attributes)
          @new_record = true
        rescue Exception => e
          arr = e.message.split(":")

          # => If we are creating this and it's a duplicate,
          # => then parse the error message for the ID
          # => A cheap way to not create duplicates without using the
          # => lookup functionality
          if arr[0].eql?("DUPLICATE_VALUE")
            puts "duplicate value, populating id"
            @id = arr[3].strip
          else
            raise e.message.inspect
          end
        end
      end

      def destroy
        @rf.destroy!(@object_name, @id) if @id
      end
    end
  end
end
