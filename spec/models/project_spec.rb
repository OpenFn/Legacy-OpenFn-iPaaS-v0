require 'rails_helper'

RSpec.describe Project, type: :model do

  it { should belong_to(:organization) }

  it { should have_many(:collaborations) }

  it { should have_many(:users) }

  it { should have_many(:mappings) }

end
