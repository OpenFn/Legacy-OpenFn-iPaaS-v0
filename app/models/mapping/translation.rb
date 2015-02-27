# Mapping Translation
# ===================
#
# Where it all comes together. Using the FieldMapping instance to:
#  - Find the values in the payload using the source_field as a path
#  - Return a destination data structure matching the destination_field as a path
#
# Then using #deeper_merge, we merge everything together creating a single
# data structure representing all destination data.
#
# The ordering and relationships for this data *does not* belong here,
# instead the dispatch adapter should be responsible for what this data
# means to the external system.

class Mapping::Translation

  def initialize(payload, field_mappings)
    # payload: the source message in hash format
    # field_mappings: set of field mappings to apply to it

    @payload = payload
    @field_mappings = field_mappings
  end

  def result
    @field_mappings.map { |field_mapping| 

      field_mapping.destination_payload_for(@payload)

    }.tap {|x| puts x.inspect}.
    dup.inject({}) { |m,o| m.deeper_merge(o, merge_hash_arrays: true, merge_debug:true) }
    
  end

end
