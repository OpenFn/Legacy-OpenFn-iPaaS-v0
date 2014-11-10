class SalesforceObject < ActiveRecord::Base

  COLORS = [
    "#7F8C8D", "#BDC3C7", "#16A085", "#2C3E50", "#2980B9", "#8E44AD", "#C0392B", "#D35400", "#F39C12", "#27AE60",
                          "#1ABC9C", "#34495E", "#3498DB", "#9B59B6", "#E74C3C", "#E67E22", "#F1C40F", "#2ECC71",
  ]

  attr_accessor :salesforce_id, :salesforce_attributes

  belongs_to :mapping
  has_many :salesforce_fields, -> { order("field_name ASC") }, dependent: :destroy
  has_many :salesforce_relationships, dependent: :destroy
  accepts_nested_attributes_for :salesforce_fields, allow_destroy: true

  after_create :set_color
  after_create :create_fields_from_salesforce

  default_scope { order("salesforce_objects.order ASC") }

  def create_fields_from_salesforce
    sf_client = RestforceService.new(self.mapping.user).connection
    sf_fields = sf_client.describe(self.name)["fields"]

    sf_fields.each do |sf_field|
      self.salesforce_fields.find_or_create_by!({
        field_name: sf_field["name"],
        data_type: (sf_field["name"].eql?("RecordTypeId") ? "record_type_id" : sf_field["type"])
      })
    end
  end

  protected

  def set_color
    self.color = (SalesforceObject::COLORS - self.mapping.salesforce_objects.collect(&:color)).first
    self.save
  end

end
