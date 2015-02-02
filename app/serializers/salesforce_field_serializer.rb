class SalesforceFieldSerializer < ActiveModel::Serializer
  attributes :id, :label_name, :field_name, :color, :properties
  def color
    object.salesforce_object.color
  end

end
