class Salesforce::Listing::Product
  attr_reader :id, :description, :name, :tags, :website, :enabled, 
              :integrated, :costs, :reviews, :resources, :provider,
              :detailed_description, :update_link, :details_active, :tech_specs

  def initialize(notification)
    raise ArgumentError, "Invalid notification: #{notification.class}" unless notification.is_a?(Salesforce::Notification)

    @id = notification.at_css('Listing_Number__c').try(:content)
    @enabled = notification.at_css('Enabled__c').try(:content)
    @integrated = notification.at_css('Integrated__c').try(:content)
    @description = notification.at_css('Description__c').try(:content)
    @name = notification.at_css('Name').try(:content)
    @tags = notification.at_css('Tags__c').try(:content)
    @website = notification.at_css('Website__c').try(:content)
    @costs = notification.at_css('Costs__c').try(:content)
    @reviews = notification.at_css('Reviews__c').try(:content)
    @resources = notification.at_css('Resources__c').try(:content)
    @provider = notification.at_css('Provider__c').try(:content)
    @detailed_description = notification.at_css('Detailed_Description__c').try(:content)
    @update_link = notification.at_css('Update_Link__c').try(:content)
    @details_active = notification.at_css('Details_Active__c').try(:content)
    @tech_specs = notification.at_css('Tech_Specs__c').try(:content)
  end
end