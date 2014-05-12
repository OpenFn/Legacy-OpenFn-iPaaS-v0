class CreateMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|
      t.string :name
      t.string :odk_formid
      t.string :salesforce_object_name
      t.timestamps
    end
  end
end
