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

    def verify credential
      connection = OdkAggregate::Connection.new(credential.url, credential.username, credential.password)

      begin
        connection.all_forms
        return true
      rescue => e
        Rails.logger.info "ODK Credential check failed with:\n#{e.backtrace.join("\n")}"
        return false
      end
    end
  end
end
