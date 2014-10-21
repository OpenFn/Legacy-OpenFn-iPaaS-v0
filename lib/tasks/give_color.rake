namespace :give_color do
  task :to_the_colorless => :environment do

    SalesforceField.update_all(color: nil)

    Mapping.all.each do |mapping|

      colors = [
        "#8989E5", "#5B5B99", "#89E5E5", "#5B9999", "#5B9999", "#E5E5E5", "#999999", "#E589C6", 
        "#995B84", "#C589E5", "#835B99", "#E58989", "#995B5B", "#E5C589", "#99835B", "#C6E589", 

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
