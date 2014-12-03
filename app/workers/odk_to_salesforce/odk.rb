module OdkToSalesforce
  ##
  # Do ODK stuff. Instantiate with a form id and fetch submission from
  # the odk.sumbmissions array
  class Odk
    attr_reader :submissions, :import

    def initialize(form_name, import, limit, user)

      @connection = OdkAggregate::Connection.new(user["odk_url"], user["odk_username"], user["odk_password"])

      # { id: "form_name", topElement: "form_top_element"}
      @form = fetch_form(form_name)

      @import = import
      @limit = limit

      fetch_submissions
    end

    # Return array of ids
    # [ id, id, id ... ]
    def fetch_submissions
      params = {formId: @form[:id], numEntries: @import.num_imported? ? @limit + @import.num_imported : @limit}
      params.merge!(cursor: transform_cursor(@import.cursor)) if @import.cursor
      @request = @connection.submissions_where(params)

      import.update(cursor: @request.opaque_data)
      @submissions = @request.submissions
    end

    def fetch_submission(id)
      @connection.submissions_where(
         formId: @form[:id],
         key: id,
         topElement: @form[:topElement]
       )

      submission = submission["submission"]["data"]
      # submission = submission["submission"]["data"]
      # submission.values.first
    end

    private

    def fetch_form(form_name)
      form = {
        id: form_name,
        topElement: @connection.find_form(form_name).get_top_element
      }
    end


    def transform_cursor(cursor)
      # <cursor xmlns=\"http://www.opendatakit.org/cursor\">
      #   <attributeName>_LAST_UPDATE_DATE</attributeName>
      #   <attributeValue>2014-10-21T05:02:58.000+0000</attributeValue>
      #   <uriLastReturnedValue>uuid:7b018f38-ba6e-48f9-99ef-5f4d6c8ad6ba</uriLastReturnedValue>
      #   <isForwardCursor>true</isForwardCursor>
      # </cursor>

      # => Reset the day to some time far in the past
      # => This allows the UUID lookup to have a lot more weight
      cursor.match(/<attributeValue>(\S+)<\/attributeValue>/) do
        cursor.gsub!($1, "2000-01-01T00:00:00.000+0000")
      end
    end
  end
end
