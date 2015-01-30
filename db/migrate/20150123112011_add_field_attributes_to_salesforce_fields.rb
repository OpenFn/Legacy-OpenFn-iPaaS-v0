class AddFieldAttributesToSalesforceFields < ActiveRecord::Migration
  def up
    add_column :salesforce_fields, :properties, :json

    SalesforceField.transaction do
      SalesforceField.unscoped.all.each do |field|

        # Skip records that have been imported after this.
        if field.data_type
          begin
            properties = field.properties || {}

            field.properties = properties.merge({
              "name" => field.field_name,
              "type" => field.data_type.camelize(:lower),
              "referenceTo" => field.reference_to ? [field.reference_to] : nil,
              "label" => field.label_name,
              "nillable" => field.nillable,
              "unique" => field.unique
            })
            field.save!
          rescue => e
            puts field.inspect
            raise e
          end
        end
      end
    end
  end

  def down
    remove_column :salesforce_fields, :properties
  end
end
