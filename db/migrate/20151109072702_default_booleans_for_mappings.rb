class DefaultBooleansForMappings < ActiveRecord::Migration
  def change
    change_column_default(:odk_sf_legacy_mappings, :slow, false)
    change_column_default(:odk_sf_legacy_mappings, :enabled, false)
  end
end
