class Mapping < ActiveRecord::Base

  has_many :mapping_fields

  accepts_nested_attributes_for :mapping_fields, reject_if: proc { |attributes| attributes['salesforce_object_field_name'].blank? }

  validates :name, presence: true
  validates :odk_formid, presence: true

end
