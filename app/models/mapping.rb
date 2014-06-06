class Mapping < ActiveRecord::Base

  has_many :salesforce_fields, dependent: :destroy

  accepts_nested_attributes_for :salesforce_fields, allow_destroy: true

  validates :name, presence: true
  validates :odk_formid, presence: true

end
