class CreateCredentialsTable < ActiveRecord::Migration
  def change
    change_table :credentials do |t|
      t.remove :label, :endpoint
      t.string :type
      t.index :type
      t.datetime :verified
    end
  end
end
