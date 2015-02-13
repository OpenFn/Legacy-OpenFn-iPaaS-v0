#designsketch

# This will NOT be ApiKeys...
# it will store the credentials used to connect to a 3rd party product API

# This will NOT be ApiKeys...
# it will store the credentials used to connect to a 3rd party product API

class Credential < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :details, :user_id

  # credential details are stored in an hstore hash called details.
end
