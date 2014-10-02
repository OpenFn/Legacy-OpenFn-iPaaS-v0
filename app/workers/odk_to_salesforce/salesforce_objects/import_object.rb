module OdkToSalesforce
  module SalesforceObjects
    class ImportObject

      include QueryMethods

      attr_accessor :id, :object_name, :attributes
      attr_reader :salesforce_object

      def initialize(rf, salesforce_object, attributes: {})
        @rf = rf
        @salesforce_object = salesforce_object
        @object_name = @salesforce_object.name
        @attributes = attributes
      end

      def populate_lookup_field(salesforce_field, odk_field_value)
        lookup_field = salesforce_field.odk_field_salesforce_fields.first.lookup_field_name || "name"
        puts "Finding object #{salesforce_field.field_name} on field #{lookup_field} with value #{odk_field_value}"
        sf_obj = @rf.query("SELECT Id FROM #{salesforce_field.field_name} WHERE #{lookup_field} = '#{odk_field_value}'").first
        @attributes[salesforce_field.field_name] = sf_obj.Id if sf_obj
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
        puts "creating #{@object_name} with attributes #{@attributes}"

        # => Rescue certain errors
        begin
          @id = @rf.create!(@object_name, @attributes)
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

      protected

      # If a field that is also a parent has a value,
      # then perform a lookup on that value.
      def find_lookup_fields
        puts "-> Looking up parents"

        @node[:parents].each do |key, values|
          # value, not key, because value is the name of the field in
          # the child object.
          values.each do |value|
            if @attributes.has_key?(value[:name].to_sym)
              field_value = @attributes[value[:name].to_sym]
              begin
                @attributes[value[:name].to_sym] = @rf.query("SELECT Id FROM #{key} WHERE #{value[:lookup_field]} = '#{field_value}'").first.Id
              rescue
                # TODO: log failed lookups
                puts "#{key} #{field_value} not found".red
                return false
              end
            end
          end
        end

        return true
      end

    end
  end
end
