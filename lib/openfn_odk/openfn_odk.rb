class OpenFn::Odk
  class << self

    # Raw Source Encoding
    # -------------------
    def encode(raw_source_payload)
      raw_source_payload["data"].first[1]
    end

    def decode(destination_payload)
    end

    def describe_object(identifier, credentials)
    end

    def list_objects(credentials)
    end
  end
end
