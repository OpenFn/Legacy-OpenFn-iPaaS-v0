namespace :give_color do
  task :to_the_colorless => :environment do

    SalesforceField.update_all(color: nil)

    Mapping.all.each do |mapping|

      colors = [
        "#7F8C8D", "#BDC3C7", "#16A085", "#2C3E50", "#2980B9", "#8E44AD", "#C0392B", "#D35400", "#F39C12", "#27AE60",
                              "#1ABC9C", "#34495E", "#3498DB", "#9B59B6", "#E74C3C", "#E67E22", "#F1C40F", "#2ECC71",
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
