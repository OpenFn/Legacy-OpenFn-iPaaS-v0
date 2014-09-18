class Mapping < ActiveRecord::Base

  belongs_to :user
  has_many :salesforce_objects, dependent: :destroy
  has_one :odk_form

  accepts_nested_attributes_for :salesforce_objects

  validates :name, presence: true
  validates :odk_formid, presence: true

end
