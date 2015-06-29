class Tagging < ActiveRecord::Base

  belongs_to :tags
  has_drafts

end
