require 'rails_helper'

RSpec.describe Organization, type: :model do

  it { should have_many(:users) }

  it { should have_many(:projects) }

  it { should belong_to(:plan) }

  it { should validate_presence_of(:name) }

end
