class DropIntegrationSources < ActiveRecord::Migration
  def change
    drop_table :integration_sources
  end
end
