require 'rails_helper'

RSpec.describe Mapping, :type => :model do
  it { should belong_to(:source_app).
       with_foreign_key(:source_connected_app_id).
       class_name( "ConnectedApp" )
  }
  it { should belong_to(:destination_app).
       with_foreign_key(:destination_connected_app_id).
       class_name( "ConnectedApp" )
  }
end

