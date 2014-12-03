module OdkToSalesforce
  class Dispatcher

    @queue = :dispatcher

    def self.perform(mapping_id, limit = 500)
      mapping = Mapping.find mapping_id
      new.perform(mapping, limit)
    end

    def perform(mapping, limit)
      # Load the log of the import for this ODK form


      # Create a new import if there isn't one yet.
      import = mapping.import || mapping.create_import(odk_formid: mapping.odk_form.name)

      # => Load the ODK information
      odk = OdkToSalesforce::Odk.new(mapping.odk_form.name, import, limit, mapping.user)

        # => Go through each submission to be processed
      odk.submissions.each do |uuid|

        # => Get the ODK Data for this submission_id from the ID
        # submission_data = odk.fetch_submission(uuid)
        # submission = import.submissions.create(uuid: uuid, data: submission_data)
        submission = odk.fetch_submission(uuid)
        submission = import.submissions.create(uuid: uuid, data: submission["data"].values.first, media_data: submission["mediaFile"].values.first)
        Resque.enqueue(OdkToSalesforce::SubmissionProcessor, mapping.id, submission.id)

      end

    end
  end
end
