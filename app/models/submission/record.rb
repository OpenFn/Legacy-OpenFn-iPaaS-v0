class Submission::Record < ActiveRecord::Base
  self.table_name = "submission_records"
  belongs_to :mapping

  validates_presence_of :mapping, :raw_source_payload

  def submitted!
    self.processed_at = Time.now
    self.save!
  end

end
