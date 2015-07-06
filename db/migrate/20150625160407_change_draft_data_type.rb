class ChangeDraftDataType < ActiveRecord::Migration
  def change
    remove_column :drafts, :object
    remove_column :drafts, :previous_draft
    add_column :drafts, :object, :json
    add_column :drafts, :previous_draft, :json
  end
end
