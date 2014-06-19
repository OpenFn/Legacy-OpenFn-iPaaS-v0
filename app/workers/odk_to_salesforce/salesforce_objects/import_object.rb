module OdkToSalesforce
  module SalesforceObjects
    class ImportObject

      include QueryMethods

      attr_accessor :node, :id, :object_name, :attributes,:parent, :children

      def initialize(rf, node: nil, attributes: {})
        @rf = rf
        @node = node
        @object_name = node[:name]
        @children = []
        @attributes = attributes
        @fields = []
      end

      def save!
        if @attributes.flatten.any? { |e| e.kind_of?(Array) }
          success_array = []
          @attributes.flatten.select { |e| e.kind_of?(Array)}[0].each_with_index do |c, i|
            flat_attributes = {}
            @attributes.each do |k,v|
              # only iterate on arrays, otherwise make value the same for all
              if v.kind_of?(Array)
                flat_attributes[k] = v[i]
              else
                flat_attributes[k] = v
              end
            end
            save_to_salesforce(flat_attributes)
          end
        else
          save_to_salesforce(@attributes)
        end

        @children.each do |child|
          child.parent = self
          child.save!
        end
      end

      def add_child(child)
        child.parent = self
        @children << child
      end

      def +(other_object)
        if self.parent.object_name.eql?(other_object.parent.object_name)
          self.parent.add_child(other_object)
        end

        self
      end

      protected

      def save_to_salesforce(attributes)
        perform_lookup = attributes.delete :perform_lookup
        if perform_lookup
          puts "finding #{@object_name} "
          @id = query(attributes)["Id"]
        else
          puts "creating #{@object_name}"
          if @parent
            attributes[@parent.object_name.to_sym] = @parent.id
          end

          # => Rescue certain errors
          begin
            @id = @rf.create!(@object_name, attributes)
          rescue Exception => e
            arr = e.message.split(":")

            # => If we are creating this and it's a duplicate,
            # => then parse the error message for the ID
            # => A cheap way to not create duplicates without using the
            # => lookup functionality
            if arr[0].eql?("DUPLICATE_VALUE")
              @id = arr[3].strip
            else
              raise e.message.inspect
            end
          end
        end
      end

    end
  end
end