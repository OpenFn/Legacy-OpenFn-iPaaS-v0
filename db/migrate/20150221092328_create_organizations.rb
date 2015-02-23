class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.belongs_to :plan, index: true
      t.integer :credits, default: 0
      t.string :name

      t.timestamps
    end
  end
end
