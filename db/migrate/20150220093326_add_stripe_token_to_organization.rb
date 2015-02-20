class AddStripeTokenToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :stripe_customer_token, :string
    add_column :organizations, :stripe_subscription_token, :string
  end
end
