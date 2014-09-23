class MappingSerializer < ActiveModel::Serializer
  root false
  attributes :id, :name, :active
  has_one :odk_form
  has_many :salesforce_objects, key: "salesforceObjects"
end
