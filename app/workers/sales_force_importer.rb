class SalesForceImporter

  def self.perform
    new.perform
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