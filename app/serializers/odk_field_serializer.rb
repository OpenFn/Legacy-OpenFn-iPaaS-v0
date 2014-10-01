class OdkFieldSerializer < ActiveModel::Serializer
  attributes :id, :field_name, :field_type, :salesforceFields

  #has_many :salesforce_fields, key: "salesforceFields"

  def salesforceFields
    arr = []

    object.odk_field_salesforce_fields.each do |odk_sf_field|
      hsh = SalesforceFieldSerializer.new(odk_sf_field.salesforce_field, root: false).as_json
      hsh[:lookupFieldName] = odk_sf_field.lookup_field_name
      arr << hsh
    end

    arr
  end

end
