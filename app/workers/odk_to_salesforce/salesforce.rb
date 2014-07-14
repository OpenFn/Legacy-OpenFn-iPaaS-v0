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
    def initialize(user)
      @rf = Restforce.new(username: user["sf_username"],
                          password: user["sf_password"],
                          security_token: user["sf_security_token"],
                          client_id: user["sf_app_key"],
                          client_secret: user["sf_app_secret"])
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

    # Get child objects
    def leaf_nodes
      leafs = []
      @relationships_hash.each do |k, v|
        if v[:children].empty?
          leafs << k
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
      get_unique_identfier_fields
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
        @relationships_hash[name] = { name: "", children: {},
                                      parents: {}, required_fields: [] }
        @relationships_hash[name][:name] = object["name"]
      end
    end

    def get_unique_identfier_fields
      puts "-> getting unique identifier fields..."
      @relationships_hash.each_key do |k|
        sf_object = @rf.describe k
        @relationships_hash[k][:uniques] = []
        sf_object["fields"].each do |f|
          @relationships_hash[k][:uniques] << f["name"] if f["unique"]
        end
      end
    end

    def get_children
      puts "-> getting children..."
      @relationships_hash.each_key do |relationship_key|
        sf_object = @rf.describe relationship_key
        sf_object["childRelationships"].each do |child_relationship|
          child_relationship_name = child_relationship["childSObject"]
          # NOTE: self-reference makes your software loopy...
          if @relationships_hash.has_key?(child_relationship_name.to_sym) &&
               child_relationship_name.to_sym != relationship_key
            @relationships_hash[relationship_key][:children][child_relationship_name.to_sym] = child_relationship["field"]
          end
        end
      end
    end

    def get_parents
      puts "-> getting parents"
      @relationships_hash.each do |current_key, current_value|
        @relationships_hash.each do |k, v|
          # if a sf object has the current object as one of its children...
          if v[:children].has_key? current_key
            # ... then it is a parent of the current object
            current_value[:parents][k] = v[:children][current_key]
          end
        end
      end
    end
  end
end
