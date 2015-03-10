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
    begin

      if valid?
        self.plan = Plan.find_by(name: subscription_plan)
        self.role = 'client_admin'

        unless subscription_plan == 'Free'
          customer = Stripe::Customer.create(email: self.email, plan: plan.try(:name), card: params[:user][:stripe_token], coupon: stripe_coupon.blank? ? nil : stripe_coupon)
          self.stripe_customer_token = customer.id
          self.stripe_subscription_token = customer.subscriptions.first.id
          self.stripe_current_period_end = Time.at(customer.subscriptions.first.current_period_end)
        end
      end

    rescue Stripe::InvalidRequestError => e
      # We leverage the errors facility to provide feedback and context to the User.
      errors.add :base, "Stripe error while creating customer: #{e.message}"
    ensure
      # Returns true if everything went ok, false otherwise. 
      # We avoid calling #valid? after called errors.add
      # since it resets all errors.
      return !!errors.any?
    end
  end

  def update_plan(params)
    # Don't attempt to update the plan if a plan isn't provided
    return true unless params[:user][:subscription_plan]

    begin
      # Don't do anything if they aren't a client_admin
      return true unless client_admin?
      # Don't do anything if they haven't changed their plan
      return true unless !changes[:plan_id]
  
      self.plan = Plan.find_by(name: params[:user][:subscription_plan])

      if stripe_customer_token.present?
        customer = Stripe::Customer.retrieve(self.stripe_customer_token)
        if stripe_coupon.present?
          customer.coupon = stripe_coupon
          customer.save
        end
        customer.update_subscription(plan: params[:user][:subscription_plan])
      else
        customer = Stripe::Customer.create({
          email: self.email, 
          plan: plan.name, 
          card: params[:user][:stripe_token], 
          coupon: stripe_coupon.blank? ? nil : stripe_coupon
        })
      end

      self.stripe_customer_token = customer.id
      self.stripe_subscription_token = customer.subscriptions.first.id

      save!

    rescue Stripe::StripeError => e
      logger.error "Stripe Error: " + e.message
      if e.message.include?("Coupon expired")
        errors.add :base, "The coupon code you've entered has expired. Plan not updated."
      elsif e.message.include?("No such coupon")
        errors.add :base, "The coupon code you've entered doesn't exist. Plan not updated."
      else
        errors.add :base, "Unable to update your subscription. #{e.message}."
      end
    ensure
      return !!errors.any?
    end
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
