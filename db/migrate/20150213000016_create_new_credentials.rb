class CreateNewCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
      t.string :label
      t.string :endpoint
      t.integer :connected_app_id
      t.hstore :details
      t.timestamps
    end
  end
end
