class OdkForm < ActiveRecord::Base
  belongs_to :mapping

  has_many :odk_fields

  accepts_nested_attributes_for :odk_fields
end
