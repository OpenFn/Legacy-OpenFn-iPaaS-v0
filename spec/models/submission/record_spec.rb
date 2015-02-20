require 'rails_helper'

RSpec.describe Submission::Record, :type => :model do

  it { should belong_to :mapping }
  
  it { should validate_presence_of :mapping }
  it { should validate_presence_of :raw_source_payload }

end
