class Salesforce::Listing::BlogPost
  attr_reader :salesforce_name, :content, :published, :publication_date

  def initialize(notification)
    raise ArgumentError, "Invalid notification: #{notification.class}" unless notification.is_a?(Salesforce::Notification)

    @salesforce_name = notification.at_css('Name').try(:content)
    @content = notification.at_css('Content__c').try(:content)
    @published = notification.at_css('Published__c').try(:content)
    @publication_date = notification.at_css('DateTime__c').try(:content)
  end
end