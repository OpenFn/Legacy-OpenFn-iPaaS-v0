class AddDetailedDescriptionToProducts < ActiveRecord::Migration
  def change
    add_column :products, :detailed_description, :text
  end
end
