class SalesforceFieldSerializer < ActiveModel::Serializer
  attributes :id, :object_name, :label_name, :field_name, :data_type, :perform_lookups

  has_many :odk_fields
end
