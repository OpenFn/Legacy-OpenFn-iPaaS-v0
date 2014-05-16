class SalesforceFieldSerializer < ActiveModel::Serializer
  attributes :id, :object_name, :field_name

  has_many :odk_fields
end
