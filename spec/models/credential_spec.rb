require 'rails_helper'

RSpec.describe Credential, :type => :model do

  it { should belong_to(:user) }
  it { should validate_presence_of(:details) }
  it { should validate_presence_of(:user_id) }
end
