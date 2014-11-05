class SetRoleOnExistingUsers < ActiveRecord::Migration
  def up
    User.all.each do |u|
      u.role = 'client'
      u.save!
    end
  end

  def down
    puts "nope"
  end
end
