class SalesforceFieldSerializer < ActiveModel::Serializer
  attributes :id, :label_name, :field_name, :data_type, :color

  def color
    object.salesforce_object.color
  end
end
