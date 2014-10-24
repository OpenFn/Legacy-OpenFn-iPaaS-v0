class AddUuidableToOdkFields < ActiveRecord::Migration
  def change
    add_column :odk_fields, :uuidable, :boolean, default: false
  end
end
