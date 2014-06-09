mapping = Mapping.find(3)
mapping.salesforce_fields.each do |sf_field|
  rf_field = Restforce.new.
    describe("#{sf_field.object_name.gsub(" ", "_")}__c")["fields"].
    select{|f| f["name"].eql?(sf_field.field_name)}.first

  sf_field.update(data_type: rf_field["type"], object_name: rf_field["name"])
end