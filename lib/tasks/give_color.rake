namespace :give_color do
  task :to_the_colorless => :environment do

    SalesforceField.update_all(color: nil)

    Mapping.all.each do |mapping|

      colors = [
        "#F7977A", "#F9AD81", "#FDC68A", "#FFF79A", "#8493CA", "#8882BE", "#A187BE", "#BC8DBF",
        "#F49AC2", "#F6989D", "#C4DF9B", "#A2D39C", "#82CA9D", "#7BCDC8", "#6ECFF6", "#7EA7D8"
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