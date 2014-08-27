class SalesforceFieldSerializer < ActiveModel::Serializer
  attributes :id,
    :object_name,
    :label_name,
    :field_name,
    :data_type,
    :is_lookup,
    :color,
    :lookup_object,
    :lookup_field
end
