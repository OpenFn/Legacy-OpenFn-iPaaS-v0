class SalesforceObjectSerializer < ActiveModel::Serializer
  attributes :name, :label, :color

  has_many :salesforce_fields, key: "salesforceFields"
end