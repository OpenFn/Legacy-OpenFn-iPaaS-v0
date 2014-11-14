class Salesforce::Notification
  attr_reader :notification

  def initialize(xml)
    raise ArgumentError, "Invalid message type: #{xml.class}" unless xml.is_a?(String) || xml.is_a?(Nokogiri::XML::Document)

    @xml = Nokogiri::XML(xml) if xml.is_a?(String)
    @xml = xml if xml.is_a?(Nokogiri::XML::Document)

    @xml.remove_namespaces!
    @notification = @xml.at_css('Notification sObject')
  end
end