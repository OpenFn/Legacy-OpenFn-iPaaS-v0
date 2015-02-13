class AddIntegrationTypeToProducts < ActiveRecord::Migration
  def change
    add_column :products, :integration_type, :string
  end
end
