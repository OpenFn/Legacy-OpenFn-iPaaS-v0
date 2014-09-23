class OdkFormSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :odk_fields
end