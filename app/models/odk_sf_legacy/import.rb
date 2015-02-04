class OdkSfLegacy::Import < ActiveRecord::Base
  self.table_name = "odk_sf_legacy_imports"

  belongs_to :mapping
  has_many :submissions, dependent: :destroy

end
