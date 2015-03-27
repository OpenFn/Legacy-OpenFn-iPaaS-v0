class AddTwitterAndEmailToProducts < ActiveRecord::Migration
  def change
    add_column :products, :twitter, :string
    add_column :products, :email, :string
  end
end
