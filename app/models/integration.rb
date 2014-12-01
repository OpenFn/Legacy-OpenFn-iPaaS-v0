#designsketch

class Integration < ActiveRecord::Base
  belongs_to :user

  belongs_to :source, class_name: "Integration::Source"
  belongs_to :destination, class_name: "Integration::Destination"

  # requires a #mappings association which stores the new form param notation: source[field] => destination[object][field]

  validates :user_id, presence: true
  validates :name, presence: true
  validates :source_id, presence: true
  validates :destination_id, presence: true
end