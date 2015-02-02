class Salesforce::Purchase::CreditPurchase

  attr_reader :attributes

  def initialize(attributes)
    unless attributes[upsert_key]
      raise ArgumentError, "Missing upsert key: #{upsert_key}"
    end

    @attributes = attributes
  end

  def upsert_key
    'PayPal_Txn_ID__c'
  end

  def object_name
    'Credit_Purchases__c'
  end
  
end
