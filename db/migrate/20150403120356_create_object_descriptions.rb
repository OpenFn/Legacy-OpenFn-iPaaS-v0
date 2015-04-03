class CreateObjectDescriptions < ActiveRecord::Migration
  def change
    create_table :object_descriptions do |t|
      t.string :name

      t.timestamps
    end
  end
end
