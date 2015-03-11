module OdkSfLegacy
  module OdkToSalesforce
    class OdkConnectionError < RuntimeError
    end

    class Dispatcher

      include Sidekiq::Worker
      sidekiq_options retry: false

      def perform(mapping_id, limit=50)
        begin
          NewRelic::Agent.add_custom_parameters(mapping_id: mapping_id, limit: limit)

          mapping = Mapping.find mapping_id
          user = mapping.user
          # Create a new import if there isn't one yet.
          import = mapping.import || mapping.create_import(odk_formid: mapping.odk_form.name)

          # => Load the ODK information
          odk = OdkToSalesforce::Odk.new(mapping.odk_form.name, import, limit, mapping.user)

          # => Go through each submission to be processed
          odk.submissions.each do |uuid|

            # => Get the ODK Data for this submission_id from the ID
            submission_data = odk.fetch_submission(uuid)
            submission = import.submissions.create(uuid: uuid, data: submission_data["data"].values.first,
                                                 media_data: submission_data["mediaFile"])
            Sidekiq::Client.enqueue(OdkToSalesforce::SubmissionProcessor, mapping.id, submission.id)

          end

        rescue Faraday::Error::TimeoutError => e
          raise OdkToSalesforce::OdkConnectionError, "Timeout Error connecting to #{mapping.user.odk_url} for Mapping##{mapping_id}"
        end

      end
    end
  end
end
