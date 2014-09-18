class CreateOdkForms < ActiveRecord::Migration
  def change
    create_table :odk_forms do |t|
      t.string :name
      t.references :mapping, index: true

      t.timestamps
    end
  end
end
