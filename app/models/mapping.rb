class Mapping < ActiveRecord::Base

  belongs_to :user
  has_many :salesforce_objects, dependent: :destroy
  has_one :odk_form

  validates :name, presence: true
  validates :odk_formid, presence: true

end
