module OdkToSalesforce
  class Dispatcher
    def self.go(mapping, only: nil)
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

    def self.get_relationships
      salesforce = OdkToSalesforce::Salesforce.new
      salesforce.relationships
    end
  end
end
