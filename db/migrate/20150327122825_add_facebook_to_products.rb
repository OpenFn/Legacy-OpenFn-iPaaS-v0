class AddFacebookToProducts < ActiveRecord::Migration
  def change
    add_column :products, :facebook, :string
  end
end
