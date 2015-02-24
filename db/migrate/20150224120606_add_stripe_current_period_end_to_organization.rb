class AddStripeCurrentPeriodEndToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :stripe_current_period_end, :string
  end
end
