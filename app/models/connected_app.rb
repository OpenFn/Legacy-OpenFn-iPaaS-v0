class ConnectedApp < ActiveRecord::Base
  has_many :object_descriptions, dependent: :destroy
end