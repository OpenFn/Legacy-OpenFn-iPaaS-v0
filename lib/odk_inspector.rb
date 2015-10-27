class OdkInspector
  attr_reader :submissions, :request
  attr_accessor :import, :form_name, :cursor

  def initialize(user)

    @connection = OdkAggregate::Connection.new(user["odk_url"], user["odk_username"], user["odk_password"])

  end

  def form_name=(name)
    @form_name=name
    @form = {
      id: name,
      topElement: @connection.find_form(name).get_top_element
    }
  end

  def reset_cursor_date!
    raise "No cursor set!" unless @cursor
    @cursor = transform_cursor(@cursor)
  end

  # Return array of ids
  # [ id, id, id ... ]
  def fetch_submissions(limit)
    raise "Please set the form_name" unless @form

    params = {
      formId: @form[:id], 
      numEntries: limit
    }

    params.merge!(cursor: cursor) if cursor

    @request = @connection.submissions_where(params)

    @submissions = @request.submissions
  end

  def fetch_submission(id)
    submission = @connection.submissions_where(
      formId: @form[:id],
      key: id,
      topElement: @form[:topElement]
    )

    submission = submission["submission"]
  end

  private

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
