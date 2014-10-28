class Import < ActiveRecord::Base

  belongs_to :mapping
  has_many :submissions, dependent: :destroy

end
