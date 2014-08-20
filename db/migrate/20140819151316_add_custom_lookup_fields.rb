class AddCustomLookupFields < ActiveRecord::Migration
  def change
    add_column :salesforce_fields, :lookup_object, :string
    add_column :salesforce_fields, :lookup_field, :string
  end
end
