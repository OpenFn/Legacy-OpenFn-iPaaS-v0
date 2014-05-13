class Mapping < ActiveRecord::Base

  has_many :odk_mapping_fields

  accepts_nested_attributes_for :odk_mapping_fields, reject_if: proc { |attributes| attributes['salesforce_mappings'].blank? }

  validates :name, presence: true
  validates :odk_formid, presence: true

end
