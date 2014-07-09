class CreateDefaultUserAndSetMappingOwner < ActiveRecord::Migration
  def change
    user = User.create! email: 'td@verasolutions.org', password: 'tdmapping!@#$', password_confirmation: 'tdmapping!@#$'
    Mapping.update_all user_id: user.id
  end
end
