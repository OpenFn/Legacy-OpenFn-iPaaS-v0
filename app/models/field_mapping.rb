class FieldMapping < ActiveRecord::Base

  belongs_to :mapping
  validates_presence_of :mapping_id, :source_field, :destination_field

  validates_format_of :source_field, with: /\//
  validates_format_of :destination_field, with: /\//

  # Source and Destination format
  # -----------------------------
  #
  # These are stored as strings, in the following format:
  # "(object name)/(key name)[/(key_name)]..."
  #
  # Each step in a path is seperated by a '/'.
  # There must be at least 1 '/' present.
  # The source and destination label (object name) *must* be present.
  
  def destination_payload_for(payload)
    # We work with string keys here for conformity.
    payload.deep_stringify_keys!

    # Paths look like this: "object/field"
    # By splitting them we can use the array to search for a set of values
    source_path = source_field.split('/')
    destination_path = destination_field.split('/')

    # Using the source path, we traverse the payload and pick out the
    # key value pairs.
    # Instead of detecting an array, we stop at -1 and grab that.
    # This works nicely when only the edge of the source path is an array.
    # Will need recursion for multi-dimensional paths.
    source_pairs = source_path[0...-1].reduce(payload) { |memo,key|
      memo[key]
    }
    
    #puts source_pairs.inspect

    # Get the values for each each source pairs.
    values = Array.wrap(source_pairs).map { |pair|
      # Use the source edge key name to get exactly the one we want.
      pair[source_path[-1]]
    }

    # Slice the destination edge/key name off the path, this will be
    # the new key for our values.
    destination_edge = destination_path.slice!(-1)
    destination_pair = values.map { |value| 
      {destination_edge => value} 
    }

    # Reattach the edge to the path.
    destination_path << destination_pair
    
    puts destination_path.inspect

    # Finally convert the rest of the path to a hash.
    Hash[*destination_path]
  end
end
