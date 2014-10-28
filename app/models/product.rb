class Product < ActiveRecord::Base
  validates :name, presence: true
  validates :logo_path, presence: true
  validates :inactive_logo_path, presence: true, if: -> (prod) { !prod.active_source || !prod.active_destination }
end
