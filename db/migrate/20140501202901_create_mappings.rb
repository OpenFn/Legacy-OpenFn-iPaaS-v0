class CreateMappings < ActiveRecord::Migration
  def change
    create_table :mappings do |t|

      t.timestamps
    end
  end
end
