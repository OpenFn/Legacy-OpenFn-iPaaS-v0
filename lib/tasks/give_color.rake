namespace :give_color do
  task :to_the_colorless => :environment do

    SalesforceField.update_all(color: nil)

    Mapping.all.each do |mapping|

      colors = [
        "#525299", "#373766", "#529999", "#376666", "#999999", "#666666", "#262626", "#D8D8D8", 
        "#995281", "#663756", "#815299", "#553766", "#995252", "#663737", "#998152", "#665637",
      ]
      colors = colors - mapping.salesforce_fields.collect(&:color).compact

      mapping.salesforce_fields.where(color: nil).group_by(&:object_name).each do |object_name, sf_fields|
        color = colors.pop
        sf_fields.each do |sf_field|
          sf_field.update(color: color)
        end
      end
    end
  end
end
