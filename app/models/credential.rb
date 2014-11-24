#designsketch

# This class is pre-existing, so I'm not going to change it.
# New design requires it to belong to integration (and User through integration)..
# There's also some polymorphism required, since each integration
# has a source and destination credential, and either of them could
# be our generated api key or a 3rd party set of credentials.
# belongs_to :product remains

# This will NOT be ApiKeys...
# it will store the credentials used to connect to a 3rd party product API

class Credential < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :details, :user_id

  # credential details are stored in an hstore hash called details.
end
