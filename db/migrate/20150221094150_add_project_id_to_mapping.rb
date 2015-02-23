class AddProjectIdToMapping < ActiveRecord::Migration
  def change
  	add_reference :mappings, :project, index: true
  end
end
