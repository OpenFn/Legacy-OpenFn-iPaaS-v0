class CreateObjectDescriptions < ActiveRecord::Migration
  def change
    create_table :object_descriptions do |t|
      t.belongs_to :connected_app, index: true
      t.string :identifier
      t.string :label
      t.json :meta

      t.timestamps
    end
  end
end