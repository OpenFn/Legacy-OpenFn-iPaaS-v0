class CreateMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|
      t.string :name
      t.string :odk_formid
      t.timestamps
    end
  end
end
