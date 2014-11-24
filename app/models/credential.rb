#designsketch

# This class is pre-existing, so I'm not going to change it.
# New design requires it to belong to integration (and User through integration)..
# There's also some polymorphism required, since each integration
# has a source and destination credential, and either of them could
# be our generated api key or a 3rd party set of credentials.
# belongs_to :product remains

class Credential < ActiveRecord::Base

  belongs_to :user
  belongs_to :product

  validates_presence_of :api_key

end
