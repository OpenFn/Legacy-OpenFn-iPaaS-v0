class ConnectedApp < ActiveRecord::Base
  belongs_to :product
  belongs_to :user

  has_many :mappings, ->(app) { where("mappings.source_connected_app_id = ? OR mappings.destination_connected_app_id = ?", app.id, app.id) }

end
