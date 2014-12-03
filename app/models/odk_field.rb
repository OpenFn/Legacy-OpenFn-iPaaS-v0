class OdkField < ActiveRecord::Base
  belongs_to :odk_form
  has_many :odk_field_salesforce_fields, dependent: :destroy
  has_many :salesforce_fields, through: :odk_field_salesforce_fields

  accepts_nested_attributes_for :salesforce_fields

  scope :repeat_fields, -> { where(repeat_field: true) }
  scope :non_repeat_fields, -> { where(repeat_field: [false,nil]) }

  validates :is_uuid, uniqueness: {scope: :odk_form_id}, if: :is_uuid

  default_scope -> { order(:id) }
end
