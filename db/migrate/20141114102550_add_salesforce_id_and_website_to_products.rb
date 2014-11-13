class AddSalesforceIdAndWebsiteToProducts < ActiveRecord::Migration
  def change
    add_column :products, :salesforce_id, :string
    add_column :products, :website, :string
  end
end
