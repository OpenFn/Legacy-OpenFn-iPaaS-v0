#designsketch

# This will NOT be ApiKeys...
# it will store the credentials used to connect to a 3rd party product API

class Credential < ActiveRecord::Base
  validates_presence_of :api_key
end
