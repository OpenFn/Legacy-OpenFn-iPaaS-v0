module OdkToSalesforce
  ##
  # Do ODK stuff. Instantiate with a form id and fetch submission from
  # the odk.sumbmissions array
  class Odk
    attr_reader :submissions

    def initialize form_id
      # { id: "form_id", topElement: "form_top_element"}
      @form = fetch_form form_id

      # Array:
      # [ id, id, id ... ]
      @submissions = fetch_submissions
    end

    def fetch_submission id
      submission = OdkAggregate::Submission.where(
                     formId: @form[:id],
                     key: id,
                     topElement: @form[:topElement]
                   )
      submission = submission["submission"]["data"]
      key = submission.keys.select { |k| k.include? @form[:id] }[0]
      submission[key]
    end

    private

    def fetch_form form_id
      form = { 
        id: form_id, 
        topElement: OdkAggregate::Form.find(form_id).get_top_element
      } 
    end

    def fetch_submissions
      puts @form
      OdkAggregate::Submission.where(formId: @form[:id]).submissions
    end
  end
end
