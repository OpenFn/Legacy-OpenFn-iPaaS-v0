module OdkToSalesforce
  ##
  # The Salesforce calass, upon instantiation, fetches a description of
  # salesforce objects from the API and builds a clean hash containing
  # useful information, of the form:
  #
  # { object_name: { name: "object_name",
  #   parents: [ array of parent objects],
  #   children: [ array of child objects ]}
  # }
  class Salesforce
    def initialize
      @rf = Restforce.new
      @relationships_hash = {}
      build
    end

    ##
    # Get relationships hash 
    def relationships
      @relationships_hash
    end

    ##
    # Get the raw JSON description that was returned by the API
    def get_raw
      @salesforce_objects
    end

    def leaf_nodes
      leafs = {} 
      @relationships_hash.each do |k, v|
        if v[:children].empty?
          leafs[k] = v
        end
      end
      leafs
    end

    private

    def build
      get_salesforce_objects
      get_names
      get_children
      get_parents
    end

    def get_salesforce_objects
      @salesforce_objects = @rf.describe.select do |object|
        object["updateable"] == true && object["custom"] == true
      end
    end

    def get_names
      puts "-> getting names..."
      @salesforce_objects.each do |object|
        name = object["name"].to_sym
        @relationships_hash[name] = { name: "", children: [],
                                      parents: [], required_fields: [] }
        @relationships_hash[name][:name] = object["name"]
      end
    end

    def get_children
      puts "-> getting children..."
      @relationships_hash.each_key do |relationship_key|
        sf_object = @rf.describe relationship_key
        sf_object["childRelationships"].each do |child_relationship|
          child_relationship = child_relationship["childSObject"]
          if @relationships_hash.has_key? child_relationship.to_sym
            @relationships_hash[relationship_key][:children] << child_relationship
          end
        end
      end
    end

    def get_parents
      puts "-> getting parents"
      @relationships_hash.each do |current_key, current_value|
        @relationships_hash.each do |k, v|
          # if a sf object has the current object as one of its children...
          if v[:children].include? current_value[:name]
            # ... then it is a parent of the current object
            current_value[:parents] << v[:name]
          end
        end
      end
    end
  end
end
