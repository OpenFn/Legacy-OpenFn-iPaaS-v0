class SalesforceFieldSerializer < ActiveModel::Serializer
  attributes :id, :object_name, :label_name, :field_name, :data_type

  has_many :odk_fields
end
