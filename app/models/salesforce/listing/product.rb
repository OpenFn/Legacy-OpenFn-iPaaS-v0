class Salesforce::Listing::Product
  attr_reader :id, :description, :name, :tags, :website

  def initialize(notification)
    raise ArgumentError, "Invalid notification: #{notification.class}" unless notification.is_a?(Salesforce::Notification)

    @id = notification.at_css('Id').content
    @description = notification.at_css('Description__c').content
    @name = notification.at_css('Name').content
    @tags = notification.at_css('Tags__c').content.split(";")
    @website = notification.at_css('Website__c').content
  end

  def attributes
    @attributes ||= {
      id: id,
      description: description,
      name: name,
      tags: tags,
      website: website
    }
  end
end