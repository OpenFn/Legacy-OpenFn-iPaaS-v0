class ChangeStripeCurrentPeriodEndToDatetime2 < ActiveRecord::Migration
  def change
    remove_column :users, :stripe_current_period_end
    add_column :users, :stripe_current_period_end, :datetime
  end
end