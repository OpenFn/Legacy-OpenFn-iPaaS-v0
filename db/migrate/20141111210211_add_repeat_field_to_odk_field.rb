class AddRepeatFieldToOdkField < ActiveRecord::Migration
  def change
    add_column :odk_fields, :repeat_field, :boolean, default: false
  end
end
