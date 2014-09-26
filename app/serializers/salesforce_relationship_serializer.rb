class SalesforceRelationshipSerializer < ActiveModel::Serializer
  has_one :salesforce_field
end