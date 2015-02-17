#designsketch

class Submission::Record < ActiveRecord::Base
  belongs_to :integration

  def submitted!
    self.processed_at = Time.now
    self.save!
  end

end
