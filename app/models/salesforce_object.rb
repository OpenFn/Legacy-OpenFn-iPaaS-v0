class SalesforceObject < ActiveRecord::Base

  COLORS = [
    "#21A5A5", "#2077A3", "#204CA3", "#2020A3", "#7720A3", "#A320A3", "#A32077", "#A32020", 						
    "#A34C20", "#A37720", "#A5A521", "#A0A0A0", "#C0C0C0", "#606060", "#EEEEEE", "#333333", 						
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
