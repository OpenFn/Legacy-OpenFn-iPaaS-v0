require 'rails_helper'

RSpec.describe Mapping, :type => :model do
  it { should belong_to :source_app }
  it { should belong_to :destination_app }
end

