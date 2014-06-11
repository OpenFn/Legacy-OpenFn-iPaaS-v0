module OdkToSalesforce
  module SalesforceObjects
    class ImportObject

      attr_accessor :id, :object_name, :attributes, :parent, :children

      def initialize(rf, obj_name: nil, attributes: {})
        @rf = rf
        @object_name = obj_name
        @children = []
        @attributes = attributes
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

      def find(id)
        # => TODO find SF object by ID
      end

      def query(attrs = {})
        # => TODO find SF object by attributes
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
        puts "creating #{@object_name}"
        attrs = attributes.reject{|k, v| k.eql?(:perform_lookup)}
        if @parent
          attrs[@parent.object_name.to_sym] = @parent.id
        end
        response = @rf.create!(@object_name, attrs)
        @id = response
      end

    end
  end
end