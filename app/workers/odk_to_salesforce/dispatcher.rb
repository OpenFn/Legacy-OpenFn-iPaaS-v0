module OdkToSalesforce
  class Dispatcher
    def self.go(mapping)
      odk = OdkToSalesforce::Odk.new(mapping.odk_formid) 
      converter = OdkToSalesforce::Converter.new(mapping)
      salesforce = OdkToSalesforce::Salesforce.new
      #runner = OdkToSalesforce::Runner.new(salesforce.relationships)

      odk.submissions[0..2].each do |submission|
        odk_data = odk.fetch_submission(submission)  
        sf_data = converter.convert(odk_data) 

        salesforce.leaf_nodes.each_key do |k|
          puts "=============================================================="
          puts "Starting runner at Salesforce object #{ salesforce.relationships[k][:name]}"
          puts "With data: "
          puts sf_data
          #runner.run(salesforce.relationships[k], sf_data) 
        end
      end
    end

    # Demo methods

    def self.convert_submission n
      converter = OdkToSalesforce::Converter.new(Mapping.first)
      odk = OdkToSalesforce::Odk.new "SRI_Baseline_Final" 
      odk_data = odk.fetch_submission odk.submissions[n]
      converter.convert odk_data
    end

    def self.get_submission n
      odk = OdkToSalesforce::Odk.new "SRI_Baseline_Final" 
      odk_data = odk.fetch_submission odk.submissions[n]
    end
  end
end
