class OdkFieldSerializer < ActiveModel::Serializer
  attributes :id, :field_name, :field_type, :sf_fields

  def sf_fields
    []
  end
end
