class AddUpdateLinkToProducts < ActiveRecord::Migration
  def change
    add_column :products, :update_link, :string
  end
end
