class AddFieldAttributesToSalesforceFields < ActiveRecord::Migration
  def up
    add_column :salesforce_fields, :properties, :json

    SalesforceField.all.each do |field|

      # Skip records that have been imported after this.
      if field.data_type

        unless field.properties
          field.properties = {}
        end

        begin
          field.properties.merge({
            type: field.data_type.camelize(:lower),
            referenceTo: field.reference_to ? [field.reference_to] : nil,
            label: field.label_name,
            nillable: field.nillable,
            unique: field.unique
          })
        rescue => e
          puts field.inspect
          raise e
        end

        field.save!
      end
    end
  end

  def down
    remove_column :salesforce_fields, :properties
  end
end
