namespace :openfn do

  desc "Create Organization For Existing Users"
  task create_organization: :environment do
  	User.all.each do |user|
      if user.organisation?
      	org = Organization.create(name: user.organisation) if user.	organization_id.blank?
      	user.update(organization_id: org.id, role: 'client_admin') if org.present?
      	puts "success"
      end
  	end
  end

end