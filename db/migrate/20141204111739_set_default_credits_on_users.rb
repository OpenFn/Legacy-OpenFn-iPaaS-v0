class SetDefaultCreditsOnUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :credits, :integer, :default => 0
  end

  def self.down
    # You can't currently remove default values in Rails
    puts "Cannot remove default value 0 from User#credits"
  end
end
