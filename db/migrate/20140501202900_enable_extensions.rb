class EnableExtensions < ActiveRecord::Migration
  def change
	enable_extension "plpgsql"
	enable_extension "hstore"
  end
end