class Mapping < ActiveRecord::Base

  has_many :salesforce_fields

  accepts_nested_attributes_for :salesforce_fields

  validates :name, presence: true
  validates :odk_formid, presence: true

end
