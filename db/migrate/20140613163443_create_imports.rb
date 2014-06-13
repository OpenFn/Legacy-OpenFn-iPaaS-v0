class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string :odk_formid
      t.string :last_uuid
      t.text :cursor

      t.timestamps
    end
  end
end
