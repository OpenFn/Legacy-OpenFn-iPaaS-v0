module OdkToSalesforce
  ##
  # The runner sets in motion the omport process. It is fed a hash of child
  # items (leafs on the dependency hash) and recursively imports up the 
  # dependencies tree.
  #
  # TODO: validate before calling parent.
  class Runner

    # - relationships: salesforce relationships hash
    def initialize relationships
      @relationships = relationships
      @rf = Restforce.new
      @sf_objects = relationships
      @imported = []
    end


    # - data: hash of salesforce data to be imported in the form:
    #   
    #   { object: { field: value } }
    def run(node)
      parentObjects = []
      model_name = node[:name]
      constraints = data[model_name]

      if(node.parents.empty?)
        return find_and_create(model_name, constraints)
      else
        node.parents.each do |parentNode|
          parentObjects << run(parentNode)
        end
      end

      if parentObjects.includes?(nil)
        return nil
      else
        parentObjects.each do |parentObject|
          parentAttributes = parentObject["attributes"]
          constraints[parentAttributes["type"]] = parentAttributes["Id"]
        end
        return find_and_create(model_name, constraints)
      end
    
    end
   

    def find_or_create(model_name, constraints)
      sf_object = find(model_name, constraints)
      if sf_object.nil?
        sf_id = create(model_name, constraints)
        sf_object = find(model_name, [{ Id: sf_id }])
      end
    end




    def find(model_name, constraints)
      query_string = "SELECT Id FROM #{model_name} WHERE "
      constraints.each do |k, v|
        query_string += "#{k} = #{v}"
      end
      @rf.query(query_string)["records"].first
    end

    # TODO
    def create item
      if @imported.includes?[item[:name].to_sym]
        return true
      if @rf.create item[:name], @data
        @imported << item
        return true
      else
        return false
      end
    end
  end
end
