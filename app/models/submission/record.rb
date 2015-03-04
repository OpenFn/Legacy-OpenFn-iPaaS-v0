class Submission::Record < ActiveRecord::Base
  self.table_name = "submission_records"
  belongs_to :mapping

  validates_presence_of :mapping_id, :raw_source_payload

  # Marshal data structures into JSON, 
  # ideally all integrations return strings.
  def raw_source_payload=(payload)
    if !payload.is_a?(String) && !payload.nil?
      return super(payload.to_json) 
    end
    super
  end

  def submitted!
    self.processed_at = Time.now
    self.save!
  end

end
