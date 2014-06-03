module OdkToSalesforce
  class Dispatcher
    def self.go(mapping)
      odk = OdkToSalesforce::Odk.new(mapping.odk_formid)
      converter = OdkToSalesforce::Converter.new(mapping)
      salesforce = OdkToSalesforce::Salesforce.new
      runner = OdkToSalesforce::Runner.new(salesforce.relationships)

      odk.submissions.each_with_index do |submission, i|
        odk_data = odk.fetch_submission(submission)
        sf_data = converter.convert(odk_data)

        salesforce.leaf_nodes.each_with_index do |k, ii|
          puts "\n\n-> dispatching submission #{i} of #{odk.submissions.length} on leaf node #{ii} of #{salesforce.leaf_nodes.size} (#{k})".yellow 
          runner.run(k.to_sym, sf_data) if sf_data.has_key?(k.to_sym)
        end
      end
    end

    def self.run_on_data(sf_object, data)
      salesforce = OdkToSalesforce::Salesforce.new
      runner = OdkToSalesforce::Runner.new(salesforce.relationships)
      runner.run(sf_object, data)
    end

    def self.convert_submission(n)
      converter = OdkToSalesforce::Converter.new(Mapping.first)
      odk = OdkToSalesforce::Odk.new "SRI_Baseline_Final"
      odk_data = odk.fetch_submission odk.submissions[n]
      converter.convert odk_data
    end

    def self.get_submission(n)
      odk = OdkToSalesforce::Odk.new "SRI_Baseline_Final"
      odk_data = odk.fetch_submission odk.submissions[n]
    end
  end
end
