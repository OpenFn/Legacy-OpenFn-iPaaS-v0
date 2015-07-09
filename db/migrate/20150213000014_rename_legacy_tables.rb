class RenameLegacyTables < ActiveRecord::Migration
  def change
    rename_table :imports, :odk_sf_legacy_imports
    rename_table :mappings, :odk_sf_legacy_mappings
    rename_table :odk_fields, :odk_sf_legacy_odk_fields
    rename_table :odk_field_salesforce_fields, :legacy_odk_field_salesforce_fields
    rename_table :odk_forms, :odk_sf_legacy_odk_forms
    rename_table :salesforce_objects, :odk_sf_legacy_salesforce_objects
    rename_table :salesforce_relationships, :legacy_salesforce_relationships
    rename_table :submissions, :odk_sf_legacy_submissions
  end
end
