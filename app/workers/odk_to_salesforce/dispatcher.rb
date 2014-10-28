module OdkToSalesforce
  class Dispatcher

    @queue = :dispatcher

    def self.perform(mapping_id, limit = 500)
      mapping = Mapping.find mapping_id
      new.perform(mapping, limit)
    end

    def perform(mapping, limit)
      # Load the log of the import for this ODK form

      import = mapping.import
      import = mapping.create_import(odk_formid: mapping.odk_form.name) if mapping.import.nil?

      # => Load the ODK information
      odk = OdkToSalesforce::Odk.new(mapping.odk_form.name, import, limit, mapping.user)

      # => Get the submissions from the ODK object
      # => The submissions only come back as IDs
      #only = odk.submissions.length if only.nil?
      #submissions = odk.submissions[0...only]
      submission_ids = odk.submissions

      # => If there are submissions to process
      if submission_ids.size > 0

        # => Go through each submission to be processed
        submission_ids.each_with_index do |submission_id, i|

          # => Get the ODK Data for this submission_id from the ID
          submission_data = odk.fetch_submission(submission_id)
          submission = import.submissions.create(uuid: submission_id, data: submission_data)
          Resque.enqueue(OdkToSalesforce::SubmissionProcessor, mapping.id, submission.id)
        end
      end
    end
  end
end
