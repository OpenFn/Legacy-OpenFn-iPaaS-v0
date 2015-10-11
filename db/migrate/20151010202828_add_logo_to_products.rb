class AddLogoToProducts < ActiveRecord::Migration
  def change
    add_column :products, :logo_url, :string
  end
end
