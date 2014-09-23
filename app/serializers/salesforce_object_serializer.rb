class SalesforceObjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :label, :color, :order, :is_repeat

  has_many :salesforce_fields, key: "salesforceFields"
end