# Salesforce Purchase
# ===================
#
# Takes a Paypal IPN message, and picks out the relevent fields
# and puts them into a CreditPurchase wrapper in order to upsert! it
# into Salesforce.
#
# We upset by PayPal Txn ID as not to duplicate payments already registered.
class Salesforce::Purchase

  attr_reader :credit_purchase

  def initialize(paypal_ipn)
    @ipn = paypal_ipn
    @credit_purchase = initialize_from_notification(@ipn)
  end

  def self.register!(paypal_ipn)
    new(paypal_ipn).register!
  end

  def register!
    Salesforce.admin_connection.upsert!(
      credit_purchase.object_name, 
      credit_purchase.upsert_key, 
      credit_purchase.attributes
    )
  end

  private

  # The second we handle more than one payment gateway, this method needs to
  # abstracted.
  def initialize_from_notification(notification)
    user_account_id = Salesforce.admin_connection.
      find('User_Account__c',notification['custom'],'Account_Number__c').Id

    purchase_date = notification['payment_date'].gsub(',','').to_datetime

    Salesforce::Purchase::CreditPurchase.new({
      'Number_Of_Credits__c' => notification['quantity'],
      'Duration__c' => notification['option_selection1'],
      'PayPal_IPN_Track_ID__c' => notification['ipn_track_id'],
      'PayPal_Payer_ID__c' => notification['payer_id'],
      'PayPal_Txn_ID__c' => notification['txn_id'],
      'Purchase_Date__c' => purchase_date,
      'User_Account__c' => user_account_id,
      #'User_Account_Email__c' => notification['payer_email']
    })
  end

end
