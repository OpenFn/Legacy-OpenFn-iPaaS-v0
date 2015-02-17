class Salesforce::Listing::UserListing
  attr_reader :id, :credits, :email, :first_name, :last_name, :organisation

  def initialize(source)
    initialize_from_user(source) if source.is_a?(::User)
    initialize_from_notification(source) if source.is_a?(Salesforce::Notification)

    # else
    raise ArgumentError, "Invalid notification: #{source.class}. Must be User or Salesforce::Notification" unless [User, Salesforce::Notification].include?(source.class)
  end

  def salesforce_object_name
    'User_Account__c'
  end

  # here we define what data is sent to Salesforce
  def salesforce_attributes
    {
      'Account_Number__c' => id,
      'Credits__c' => credits,
      'Email__c' => email,
      'First_Name__c' => first_name,
      'Last_Name__c' => last_name,
      'Organization__c' => organisation,
      'Role__c' => role,
      'Tier__c' => tier,
    }
  end

  def salesforce_upsert_key
    'Account_Number__c'
  end

  def attributes
    {
      'id' => id,
      'credits' => credits,
      'email' => email,
      'first_name' => first_name,
      'last_name' => last_name,
      'organisation' => organisation,
      'role' => role,
      'tier' => tier,
    }
  end

  private
  
    def initialize_from_user(user)
      @id = user.id
      @credits = user.credits || 0
      @email = user.email
      @first_name = user.first_name
      @last_name = user.last_name
      @organisation = user.organisation
      @role = user.role
      @tier = user.tier
    end

    # This is to map incoming notifications from Salesforce to our DB
    # def initialize_from_notification(notification)
    #   Account_Number__c is the FK for id for a User.
    #   @id = notification.at_css('Account_Number__c').try(:content)
    #   @credits = notification.at_css('Credits__c').try(:content)
    #   @email = notification.at_css('Email__c').try(:content)
    #   @first_name = notification.at_css('First_Name__c').try(:content)
    #   @last_name = notification.at_css('Last_Name__c').try(:content)
    #   @organisation = notification.at_css('Organization__c').try(:content)
    #   @role = notification.at_css('Role__c').try(:content)
    #   @tier = notification.at_css('Tier__c').try(:content)
    #   @sf_id = notifcation.at_css('Id').try(:content)
    # end
end