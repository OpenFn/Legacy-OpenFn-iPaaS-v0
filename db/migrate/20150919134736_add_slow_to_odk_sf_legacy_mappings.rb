class AddSlowToOdkSfLegacyMappings < ActiveRecord::Migration
  def change
    add_column :odk_sf_legacy_mappings, :slow, :boolean
  end
end
