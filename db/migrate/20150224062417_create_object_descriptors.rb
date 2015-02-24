class CreateObjectDescriptors < ActiveRecord::Migration
  def change
    create_table :object_descriptors do |t|
      t.belongs_to :object_description, index: true
      t.string :identifier
      t.string :label
      t.boolean :hidden
      t.json :meta

      t.timestamps
    end
  end
end
