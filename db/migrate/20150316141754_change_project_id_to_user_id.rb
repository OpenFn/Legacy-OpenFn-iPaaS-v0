class ChangeProjectIdToUserId < ActiveRecord::Migration
  def change
    rename_column :mappings, :project_id, :user_id
  end
end
