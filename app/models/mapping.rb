class Mapping < ActiveRecord::Base

  has_many :field_mappings
  belongs_to :source_app, class_name: "ConnectedApp"
  belongs_to :destination_app, class_name: "ConnectedApp"
end