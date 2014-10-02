module OdkToSalesforce
  class Dispatcher

    @queue = :importer

    def self.perform(mapping_id, limit = 500)
      mapping = Mapping.find mapping_id
      new.perform(mapping, limit)
    end

    def perform(mapping, limit)
      # Load the log of the import for this ODK form
      import = Import.find_or_create_by(odk_formid: mapping.odk_form.name)

      # => Load the ODK information
      odk = OdkToSalesforce::Odk.new(mapping.odk_form.name, import, limit, mapping.user)

      # => Get the submissions from the ODK object
      # => The submissions only come back as IDs
      #only = odk.submissions.length if only.nil?
      #submissions = odk.submissions[0...only]
      submissions = odk.submissions

      # => If there are submissions to process
      if submissions.size > 0

        # => Go through each submission to be processed
        submissions.each_with_index do |submission, i|

          # => Get the ODK Data for this submission from the ID
          submission_data = odk.fetch_submission(submission)
          OdkToSalesforce::SubmissionProcessor.perform(submission_data, mapping)

          # import.update(last_uuid: submission, num_imported: import.num_imported + 1)
        end
      end
    end
  end
end
