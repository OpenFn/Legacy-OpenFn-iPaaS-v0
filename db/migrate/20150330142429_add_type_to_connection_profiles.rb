class AddTypeToConnectionProfiles < ActiveRecord::Migration
  def change
    add_column :connection_profiles, :type, :string
  end
end
