module OdkToSalesforce
  module SalesforceObjects
    module QueryMethods

      def query(attributes)
        query_string = "SELECT Id FROM #{object_name} WHERE "
        conditions = []

        attrs = lookup_fields(attributes)
        attrs.each do |k,v|
          quote = v.kind_of?(String) ? "'" : ""

          if valid_for_query?(k)
            # => Set the lookup value so empty strings can be compared too
            lookup = "#{quote}#{v}#{quote}"
            conditions << "#{k} = #{lookup}" unless lookup.blank?
          end
        end

        operator = has_uniques?(attributes) ? "OR" : "AND"
        @rf.query(query_string + conditions.join(" #{operator} "))["records"].first
      end

      def valid_for_query?(key)
        ![:Repayment_Problem_Explanation__c].include?(key)
      end

      def has_uniques?(attributes)
        !attributes.select{|k, v| @node[:uniques].include?(k.to_s)}.empty?
      end

      def lookup_fields(attributes)
        attrs = attributes.select{|k, v| @node[:uniques].include?(k.to_s)}
        attrs = attributes if attrs.empty?
      end
    end
  end
end