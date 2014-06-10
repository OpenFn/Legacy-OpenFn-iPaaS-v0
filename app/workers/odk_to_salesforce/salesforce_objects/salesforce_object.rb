module OdkToSalesforce
  module SalesforceObjects
    class SalesforceObject

      attr_accessor :id, :object_name, :attributes, :parent, :children

      def initialize(rf, obj_name: nil, attributes: {})
        @rf = rf
        @object_name = obj_name
        @children = []
        @attributes = attributes
      end

      def find(id)

      end

      def query(attrs = {})

      end

      def add_child(child)
        child.parent = self
        @children << child
      end
    end
  end
end