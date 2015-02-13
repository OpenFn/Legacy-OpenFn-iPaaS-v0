class CreateSubmissionRecords < ActiveRecord::Migration
  def change
    create_table :submission_records do |t|
      t.integer :integration_id
      t.text :raw_source_payload
      t.hstore :source_payload
      t.hstore :destination_payload
      t.text :raw_destination_payload
      t.datetime :processed_at
    end
  end
end
