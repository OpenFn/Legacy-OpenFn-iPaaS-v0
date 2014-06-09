class MappingSerializer < ActiveModel::Serializer
  attributes :id, :name, :active, :odk_formid

  has_many :salesforce_fields
end
