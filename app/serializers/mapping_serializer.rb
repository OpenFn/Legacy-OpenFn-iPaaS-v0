class MappingSerializer < ActiveModel::Serializer
  root false
  attributes :id, :name, :active, :enabled, :can_be_enabled
  has_one :odk_form
  has_many :salesforce_objects, root: "salesforceObjects"
end
