class ChangePayloadsToJson < ActiveRecord::Migration
  def up
    remove_columns :submission_records, :source_payload, :destination_payload
    add_column :submission_records, :source_payload, :json
    add_column :submission_records, :destination_payload, :json
  end
end
