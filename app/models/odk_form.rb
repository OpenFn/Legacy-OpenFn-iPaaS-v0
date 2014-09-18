class OdkForm < ActiveRecord::Base
  belongs_to :mapping

  has_many :odk_fields
end
