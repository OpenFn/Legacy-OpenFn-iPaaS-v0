class MappingSerializer < ActiveModel::Serializer
  attributes :id, :name, :odk_formid

  has_many :salesforce_fields
end
