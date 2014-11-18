module OdkToSalesforce
  ##
  # Do ODK stuff. Instantiate with a form id and fetch submission from
  # the odk.sumbmissions array
  class Odk
    attr_reader :submissions, :import

    def initialize(form_id, import, limit, user)

      @connection = OdkAggregate::Connection.new(user["odk_url"], user["odk_username"], user["odk_password"])

      # { id: "form_id", topElement: "form_top_element"}
      @form = fetch_form(form_id)

      @import = import
      @limit = limit

      fetch_submissions
    end

    # Return array of ids
    # [ id, id, id ... ]
    def fetch_submissions
      params = {formId: @form[:id], numEntries: @import.num_imported? ? @limit + @import.num_imported : @limit}
      params.merge!(cursor: transform_cursor(@import.cursor)) if @import.cursor && @import.last_uuid
      @request = @connection.submissions_where(params)

      import.update(cursor: @request.opaque_data)
      @submissions = @request.submissions
    end

    def fetch_submission(id)
      submission = @connection.submissions_where(
         formId: @form[:id],
         key: id,
         topElement: @form[:topElement]
       )

      submission = submission["submission"]["data"]
      submission.values.first
    end

    private

    def fetch_form(form_id)
      form = {
        id: form_id,
        topElement: @connection.find_form(form_id).get_top_element
      }
    end


    def transform_cursor(cursor)
      # => Reset the day to some time far in the past
      # => This allows the UUID lookup to have a lot more weight
      cursor.match(/<attributeValue>(\S+)<\/attributeValue>/) do
        cursor.gsub!($1, "2000-01-01T00:00:00.000+0000")
      end
      cursor.match(/<uriLastReturnedValue>(\S+)<\/uriLastReturnedValue>/) do
        cursor.gsub!($1, @import.last_uuid)
      end
    end
  end
end
