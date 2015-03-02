class AddStripeDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_token, :string
    add_column :users, :stripe_subscription_token, :string
    add_column :users, :stripe_curent_period_end, :string
  end
end
