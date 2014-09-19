class OdkFormSerializer < ActiveModel::Serializer
  attributes :name

  has_many :odk_fields
end