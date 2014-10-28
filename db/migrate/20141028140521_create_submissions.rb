class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :uuid
      t.string :state
      t.json :data
      t.references :import

      t.timestamps
    end
  end
end
