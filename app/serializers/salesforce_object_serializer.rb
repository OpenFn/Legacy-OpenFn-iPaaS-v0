class SalesforceObjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :label, :color, :order, :is_repeat, :relationshipFields

  has_many :salesforce_fields, root: "salesforceFields"

  def relationshipFields
    arr = []

    object.salesforce_relationships.each do |relationship|
      arr << SalesforceFieldSerializer.new(relationship.salesforce_field, root: false).as_json
    end

    arr
  end
end