module OdkToSalesforce
  class SalesforceImporter
    def self.perform 
      runner = OdkToSalesforce::Runner.new
      runner.run
    end

    def self.whatevs
      odk = OdkToSalesforce::Odk.new "SRI_Baseline_Final" 
      odk_data = odk.fetch_submission odk.submissions.first

      converter = OdkToSalesforce::Converter.new Mapping.first

      converter.convert odk_data
    end

    def initialize
      @client = Restforce.new
    end
  
    def perform
      #@client.describe
      @client.describe('Account')
      #accounts = @client.query("select Id from Position__c")
      #raise accounts.inspect
    end


  end
end
