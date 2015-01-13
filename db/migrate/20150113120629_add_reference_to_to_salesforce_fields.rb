class AddReferenceToToSalesforceFields < ActiveRecord::Migration
  def change
    # Adding referenceTo support, for relationships with different names to
    # their related object.
    add_column :salesforce_fields, :reference_to, :string

    # Cleaning up, parent objects are kept on salesforce_objects.
    remove_column :salesforce_fields, :object_name, :string
    remove_column :salesforce_fields, :mapping_id, :integer

    # Cleaning up, lookups are kept on odk_fields_salesforce_fields.
    remove_column :salesforce_fields, :lookup_object, :string
    remove_column :salesforce_fields, :lookup_field, :string
  end
end
