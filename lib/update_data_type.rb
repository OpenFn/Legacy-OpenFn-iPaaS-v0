mapping = Mapping.find(3)
mapping.salesforce_fields.each do |sf_field|
  object_name = sf_field.object_name
  object_name = "#{sf_field.object_name.gsub(" ", "_")}__c" unless object_name.include?("__c")
  rf_object = Restforce.new.describe(object_name)
  object_name = rf_object["name"]

  rf_field = rf_object["fields"].
    select{|f| f["name"].eql?(sf_field.field_name)}.first

  sf_field.update(data_type: rf_field["type"], object_name: object_name, label_name: rf_object["label"])
end