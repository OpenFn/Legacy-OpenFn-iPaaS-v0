class AddTitleToTeamMembers < ActiveRecord::Migration
  def change
  	add_column :team_members, :title, :string
  end
end