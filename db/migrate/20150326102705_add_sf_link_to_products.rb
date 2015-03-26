class AddSfLinkToProducts < ActiveRecord::Migration
  def change
    add_column :products, :sf_link, :string
  end
end
