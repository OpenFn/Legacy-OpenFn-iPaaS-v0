class AddFieldAttributesToSalesforceFields < ActiveRecord::Migration
  def up
    add_column :salesforce_fields, :properties, :json
    SalesforceField.all.each do |field|
      field.update!(properties: {
        type: field.data_type.camelize(:lower),
        referenceTo: field.reference_to,
        label: field.label_name,
        nillable: field.nillable,
        unique: field.unique
      })
    end
  end

  def down
    remove_column :salesforce_fields, :properties
  end
end
