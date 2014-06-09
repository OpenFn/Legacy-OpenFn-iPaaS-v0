module OdkToSalesforce
  class Dispatcher

    @queue = :importer

    def self.perform(mapping_id, only = nil)
      mapping = Mapping.find mapping_id
      new.perform(mapping, only)
    end

    def perform(mapping, only)
      odk = OdkToSalesforce::Odk.new(mapping.odk_formid)
      converter = OdkToSalesforce::Converter.new(mapping)
      salesforce = OdkToSalesforce::Salesforce.new
      runner = OdkToSalesforce::Runner.new(salesforce.relationships)

      only = odk.submissions.length if only.nil?
      submissions = odk.submissions[0...only]

      submissions.each_with_index do |submission, i|
        odk_data = odk.fetch_submission(submission)
        sf_data = converter.convert(odk_data)

        salesforce.leaf_nodes.each_with_index do |k, ii|
          puts "\n\n-> dispatching submission #{i + 1} of #{submissions.length} on leaf node #{ii + 1} of #{salesforce.leaf_nodes.size} (#{k})".yellow
          runner.run(k.to_sym, sf_data) if sf_data.has_key?(k.to_sym)
        end
      end
    end
  end
end
