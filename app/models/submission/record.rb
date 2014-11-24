class Submission::Record < ActiveRecord::Base
  # schema:
  # create_table :submission_records do |t|
  #   t.integer :integration_id
  #   t.text :source_payload # json-serialised, possibly hstore
  #   t.text :destination_payload # json-serialised, possibly hstore
  #   t.string :state
  # end

  # Could be useful for tracking submission progress through the pipeline
  # Could also be dangerous, since who's responsibility it is to perform
  # the transition events is unclear.
  # state_machine :state, :initial => :received do
  #   event :translated do
  #     transition [:received] => :translated
  #   end

  #   event :sent do
  #     transition [:translated] => :sent
  #   end
  # end
end