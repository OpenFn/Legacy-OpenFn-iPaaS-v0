module OdkToSalesforce
  class SalesforceImporter
    def self.perform 
      runner = OdkToSalesforce::Runner.new
      runner.run
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
