namespace :give_color do
  task :to_the_colorless => :environment do

    SalesforceField.update_all(color: nil)

    Mapping.all.each do |mapping|

      colors = [
        "#21A5A5", "#2077A3", "#204CA3", "#2020A3", "#7720A3", "#A320A3", "#A32077", "#A32020", 						
        "#A34C20", "#A37720", "#A5A521", "#A0A0A0", "#C0C0C0", "#606060", "#EEEEEE", "#333333", 						
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
