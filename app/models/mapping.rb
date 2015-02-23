class Mapping < ActiveRecord::Base

  has_many :field_mappings
  belongs_to :source_app, class_name: "ConnectedApp", foreign_key: "source_connected_app_id"
  belongs_to :destination_app, class_name: "ConnectedApp", foreign_key: "destination_connected_app_id"
end
