class AddIsUuidToOdkField < ActiveRecord::Migration
  def change
    add_column :odk_fields, :is_uuid, :boolean, default: false
  end
end
