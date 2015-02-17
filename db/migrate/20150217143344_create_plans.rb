class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :price
      t.integer :project_limit
      t.integer :user_limit
      t.integer :connected_app_limit
      t.integer :map_limit
      t.string :support_type
      t.integer :job_limit
      t.string :sync_interval

      t.timestamps
    end
  end
end
