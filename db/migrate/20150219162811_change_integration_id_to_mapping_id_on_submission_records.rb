class ChangeIntegrationIdToMappingIdOnSubmissionRecords < ActiveRecord::Migration
  def change
    rename_column :submission_records, :integration_id, :mapping_id
  end
end
