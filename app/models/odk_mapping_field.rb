class OdkMappingField < ActiveRecord::Base
  attr_accessor :salesforce_mappings

  belongs_to :mapping
  has_many :salesforce_mapping_fields

  after_save :process_salesforce_mappings

  protected

  def process_salesforce_mappings
    self.salesforce_mappings.split(',').each do |sf_field|
      object_name, field_name = sf_field.split(":")
      self.salesforce_mapping_fields.create!(object_name: object_name, field_name: field_name)
    end
  end
end
