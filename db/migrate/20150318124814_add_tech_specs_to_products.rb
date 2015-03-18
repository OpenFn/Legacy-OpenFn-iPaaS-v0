class AddTechSpecsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :tech_specs, :text
  end
end
