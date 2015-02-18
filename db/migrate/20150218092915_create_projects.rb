class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.belongs_to :organization, index: true

      t.timestamps
    end
  end
end
