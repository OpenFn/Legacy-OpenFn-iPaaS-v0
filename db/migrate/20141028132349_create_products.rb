class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :logo_path
      t.string :inactive_logo_path
      t.boolean :active_source
      t.boolean :active_destination
    end
  end
end
