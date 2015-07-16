class CreateTeamMember < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
    	t.string :name
    	t.text :bio
    	t.string :picture_url
    	t.integer :order
    end
  end
end
