class OdkFieldSerializer < ActiveModel::Serializer
  attributes :id, :field_name, :field_type

  has_many :salesforce_fields, key: "salesforceFields"

end
