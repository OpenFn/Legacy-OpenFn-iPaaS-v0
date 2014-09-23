class SalesforceObjectSerializer < ActiveModel::Serializer
  attributes :name, :label, :color, :order

  has_many :salesforce_fields, key: "salesforceFields"
end