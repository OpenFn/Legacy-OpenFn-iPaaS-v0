mapping = Mapping.find(3)
mapping.salesforce_fields.each do |sf_field|
  rf_object = Restforce.new.describe("#{sf_field.object_name.gsub(" ", "_")}__c")
  object_name = rf_object["name"]

  rf_field = rf_object["fields"].
    select{|f| f["name"].eql?(sf_field.field_name)}.first

  sf_field.update(data_type: rf_field["type"], object_name: object_name)
end