class OdkSfLegacy::Credential < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :details, :user_id

  # credential details are stored in an hstore hash called details.
end
