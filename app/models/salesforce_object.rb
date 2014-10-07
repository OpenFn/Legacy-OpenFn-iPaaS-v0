class SalesforceObject < ActiveRecord::Base

  COLORS = [
    "#F7977A", "#F9AD81", "#FDC68A", "#FFF79A", "#8493CA", "#8882BE", "#A187BE", "#BC8DBF",
    "#F49AC2", "#F6989D", "#C4DF9B", "#A2D39C", "#82CA9D", "#7BCDC8", "#6ECFF6", "#7EA7D8"
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
    self.color = (SalesforceObject::COLORS - self.mapping.salesforce_objects.collect(&:color)).shuffle.first
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
