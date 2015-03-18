class CreateCredentials < ActiveRecord::Migration
  def change
    create_table :credentials do |t|
    	t.hstore :details

      t.timestamps
    end
  end
end
