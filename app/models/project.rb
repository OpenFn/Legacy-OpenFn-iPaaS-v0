class Project < ActiveRecord::Base
  has_many :collaborations, dependent: :destroy
  has_many :users, through: :collaborations
  has_many :mappings, dependent: :destroy
  belongs_to :organization

  validate :validate_projects, on: :create

  def validate_projects
    if organization.projects.count >= project_limits
      errors.add :base, "Organization has reached to the max project limit"
    end
  end

  private
    def project_limits
      organization.plan.project_limit rescue 1
    end
end
