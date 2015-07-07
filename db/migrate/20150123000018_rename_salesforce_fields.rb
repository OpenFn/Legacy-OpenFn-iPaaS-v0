class RenameSalesforceFields < ActiveRecord::Migration
  def change
    rename_table :salesforce_fields, :odk_sf_legacy_salesforce_fields
  end
end
