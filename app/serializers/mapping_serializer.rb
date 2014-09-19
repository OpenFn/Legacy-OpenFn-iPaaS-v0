class MappingSerializer < ActiveModel::Serializer
  attributes :id, :name, :active#, :odk_formid, :mappedSfObjects, :odkFormFields
  has_one :odk_form

  def mappedSfObjects
    object.salesforce_fields.collect{|sf|
      {
        name: sf.object_name,
        label: sf.label_name,
        color: sf.color
      }
    }.uniq
  end

  def odkFormFields
    arr = []

    object.salesforce_fields.each do |sf_field|
      sf_field.odk_fields.each do |odk_field|
        odk_hash = OdkFieldSerializer.new(odk_field, root: false).as_json
        odk_hash[:sf_fields] << SalesforceFieldSerializer.new(sf_field, root: false).as_json
        arr << odk_hash
      end
    end

    arr
  end

end
