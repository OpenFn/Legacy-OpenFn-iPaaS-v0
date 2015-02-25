class ObjectDescription < ActiveRecord::Base
  belongs_to :connected_app
  has_many :object_descriptors, dependent: :destroy

  accepts_nested_attributes_for :object_descriptors, allow_destroy: true, reject_if: :all_blank
end