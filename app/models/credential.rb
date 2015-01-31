#designsketch

# This will NOT be ApiKeys...
# it will store the credentials used to connect to a 3rd party product API

class Credential < ActiveRecord::Base
  belongs_to :user # #designsketch - decomission this. It should go through connected app to user
  belongs_to :connected_app
  validates_presence_of :details, :connected_app_id, :user_id

  # credential details are stored in an hstore hash called details.
end
