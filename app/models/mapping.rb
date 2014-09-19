class Mapping < ActiveRecord::Base

  belongs_to :user
  has_many :salesforce_objects, dependent: :destroy
  has_one :odk_form

  accepts_nested_attributes_for :odk_form

  validates :name, presence: true
  validates :odk_form, presence: true

end
