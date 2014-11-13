class ChangeSubmissionsMessagesToText < ActiveRecord::Migration
    def change
      change_column :submissions, :message, :text
    end
end
