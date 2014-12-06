class AddMediaDataToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :media_data, :json
  end
end
