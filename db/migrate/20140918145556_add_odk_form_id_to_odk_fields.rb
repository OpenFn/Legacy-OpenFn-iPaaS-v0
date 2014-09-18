class AddOdkFormIdToOdkFields < ActiveRecord::Migration
  def change
    add_reference :odk_fields, :odk_form, index: true
  end
end
