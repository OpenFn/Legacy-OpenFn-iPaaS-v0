class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :synced, :stripe_token, :subscription_plan, :stripe_coupon

  has_many :mappings, dependent: :destroy, class_name: "OdkSfLegacy::Mapping"
  has_many :collaborations, dependent: :destroy
  has_many :projects, through: :collaborations
  belongs_to :organization

  validates :password, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  validates :email, uniqueness: true, presence: true
  validates :first_name, :last_name, presence: true
  validates :role, inclusion: { in: %w(client client_admin admin), message: "%{value} is not a valid role" }

  accepts_nested_attributes_for :organization, allow_destroy: true

  before_validation :set_default_role, on: :create
  after_create :set_role

  def admin?
    self.role == 'admin'
  end

  def client_admin?
    role == 'client_admin'
  end

  def client?
    role == 'client'
  end

  def has_available_mapping_credits?
    MappingLimiter.new(self).credits_available?
  end

  def save_with_payment(params)
    if valid?
      org = Organization.new(name: params[:organization_name])
      plan = Plan.find_by(name: subscription_plan)
      org.plan_id = plan.try(:id)
      unless subscription_plan == 'Free'
        customer = Stripe::Customer.create(description: org.id, plan: plan.name, card: params[:user][:stripe_token], coupon: stripe_coupon.blank? ? nil : stripe_coupon)
        org.stripe_customer_token = customer.id
        org.stripe_subscription_token = customer.subscriptions.first.id
        org.save
        self.organization_id = org.id
        save!
      else
        org.save
        self.organization_id = org.id
        save
      end
    end
  rescue Stripe::InvalidRequestError => e
    errors.add :base, "Stripe error while creating customer: #{e.message}"
    false
  end

  def update_plan(params)
    if (self.client_admin? && organization.plan.try(:name) != params[:user][:subscription_plan]) || stripe_coupon.present?
      plan = Plan.find_by(name: params[:user][:subscription_plan])
      if organization.stripe_customer_token.present?
        customer = Stripe::Customer.retrieve(organization.stripe_customer_token)
        if stripe_coupon.present?
          customer.coupon = stripe_coupon
          customer.save
        end
        customer.update_subscription(plan: params[:user][:subscription_plan])
      else
        customer = Stripe::Customer.create(description: organization.id, plan: plan.name, card: params[:user][:stripe_token], coupon: stripe_coupon.blank? ? nil : stripe_coupon)
      end
      organization.plan_id = plan.id
      organization.stripe_customer_token = customer.id
      organization.stripe_subscription_token = customer.subscriptions.first.id
      organization.save
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    errors.add :base, "Unable to update your subscription. #{e.message}."
    false
  end

  private
    def set_default_role
      self.role ||= 'client'
    end

    def set_role
      self.update(role: 'client_admin') if organization.present?
    end

end