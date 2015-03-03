class User < ActiveRecord::Base
  authenticates_with_sorcery!

  attr_accessor :synced, :stripe_token, :subscription_plan, :stripe_coupon

  has_many :mappings, dependent: :destroy, class_name: "OdkSfLegacy::Mapping"
  # has_many :collaborations, dependent: :destroy
  # has_many :projects, through: :collaborations
  # belongs_to :organization
  belongs_to :plan

  validates :password, length: { minimum: 3 }, on: :create
  validates :password, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  validates :email, uniqueness: true, presence: true
  validates :first_name, :last_name, presence: true
  validates :role, inclusion: { in: %w(client client_admin admin), message: "%{value} is not a valid role" }

  validates :organisation, presence: true
  # accepts_nested_attributes_for :organization, allow_destroy: true

  before_validation :set_default_role, on: :create
  before_destroy :cancel_subscription

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
      plan = Plan.find_by(name: subscription_plan)
      unless subscription_plan == 'Free'
        customer = Stripe::Customer.create(email: self.email, plan: plan.try(:name), card: params[:user][:stripe_token], coupon: stripe_coupon.blank? ? nil : stripe_coupon)
        self.stripe_customer_token = customer.id
        self.stripe_subscription_token = customer.subscriptions.first.id
        self.stripe_curent_period_end = Time.at(customer.subscriptions.first.current_period_end)
        self.plan_id = plan.try(:id)
        self.role = 'client_admin'
        save!
      else
        self.role = 'client_admin'
        save
      end
    end
  rescue Stripe::InvalidRequestError => e
    errors.add :base, "Stripe error while creating customer: #{e.message}"
    false
  end

  def update_plan(params)
    if (self.client_admin? && self.plan.try(:name) != params[:user][:subscription_plan]) || stripe_coupon.present?
      plan = Plan.find_by(name: params[:user][:subscription_plan])
      if self.stripe_customer_token.present?
        customer = Stripe::Customer.retrieve(self.stripe_customer_token)
        if stripe_coupon.present?
          customer.coupon = stripe_coupon
          customer.save
        end
        customer.update_subscription(plan: params[:user][:subscription_plan])
      else
        customer = Stripe::Customer.create(email: self.email, plan: plan.name, card: params[:user][:stripe_token], coupon: stripe_coupon.blank? ? nil : stripe_coupon)
      end
      self.plan_id = plan.id
      self.stripe_customer_token = customer.id
      self.stripe_subscription_token = customer.subscriptions.first.id
      save
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

    def cancel_subscription
      unless stripe_customer_token.nil?
        customer = Stripe::Customer.retrieve(stripe_customer_token)
        unless customer.nil?
          customer.cancel_subscription
        end
      end
    rescue Stripe::StripeError => e
      logger.error "Stripe Error: " + e.message
      errors.add :base, "Unable to cancel your subscription. #{e.message}."
      false
    end

end