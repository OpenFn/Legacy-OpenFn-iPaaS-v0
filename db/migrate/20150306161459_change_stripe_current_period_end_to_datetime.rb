class ChangeStripeCurrentPeriodEndToDatetime < ActiveRecord::Migration
  def change
  	change_table :users do |t|
      t.rename :stripe_curent_period_end, :stripe_current_period_end
    end
  end
end
