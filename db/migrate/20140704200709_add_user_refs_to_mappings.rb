class AddUserRefsToMappings < ActiveRecord::Migration
  def change
    add_reference :mappings, :user, index: true
  end
end
