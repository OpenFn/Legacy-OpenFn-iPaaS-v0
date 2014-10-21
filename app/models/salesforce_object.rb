class SalesforceObject < ActiveRecord::Base

  COLORS = [
    "#8989E5", "#5B5B99", "#89E5E5", "#5B9999", "#5B9999", "#E5E5E5", "#999999", "#E589C6", 
    "#995B84", "#C589E5", "#835B99", "#E58989", "#995B5B", "#E5C589", "#99835B", "#C6E589", 
  ]

  attr_accessor :salesforce_id, :salesforce_attributes

  belongs_to :mapping
  has_many :salesforce_fields, dependent: :destroy
  has_many :salesforce_relationships, dependent: :destroy
  accepts_nested_attributes_for :salesforce_fields, allow_destroy: true

  after_create :set_color
  after_create :create_fields

  default_scope { order("salesforce_objects.order ASC") }

  protected

  def set_color
    self.color = (SalesforceObject::COLORS - self.mapping.salesforce_objects.collect(&:color)).first
    self.save
  end

  def create_fields
    sf_client = RestforceService.new(self.mapping.user).connection

    sf_fields = sf_client.describe(self.name)["fields"]

    sf_fields.each do |sf_field|
      self.salesforce_fields.create!(
        field_name: sf_field["name"],
        data_type: sf_field["type"]
      )
    end
  end

end
