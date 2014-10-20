class SalesforceObject < ActiveRecord::Base

  COLORS = [
    "#525299", "#373766", "#529999", "#376666", "#999999", "#666666", "#262626", "#D8D8D8", 
    "#995281", "#663756", "#815299", "#553766", "#995252", "#663737", "#998152", "#665637", 
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
