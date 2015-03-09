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
      self.role = 'client_admin'
      unless subscription_plan == 'Free'
        customer = Stripe::Customer.create(email: self.email, plan: plan.try(:name), card: params[:user][:stripe_token], coupon: stripe_coupon.blank? ? nil : stripe_coupon)
        self.stripe_customer_token = customer.id
        self.stripe_subscription_token = customer.subscriptions.first.id
        self.stripe_curent_period_end = Time.at(customer.subscriptions.first.current_period_end)
        self.plan_id = plan.try(:id)
        save!
      else
        self.plan_id = plan.try(:id)
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
      self.stripe_curent_period_end = Time.at(customer.subscriptions.first.current_period_end)
      save!
    else
      true
    end
  rescue Stripe::StripeError => e
    logger.error "Stripe Error: " + e.message
    if e.message.include?("Coupon expired")
      errors.add :base, "The coupon code you've entered has expired. Plan not updated."
    elsif e.message.include?("No such coupon")
      errors.add :base, "The coupon code you've entered doesn't exist. Plan not updated."
    else
      errors.add :base, "Unable to update your subscription. #{e.message}."
    end
    false
  end

  def plan_period_start
    stripe_current_period_end? ? stripe_current_period_end - 1.month : Date.current.beginning_of_month
  end

  def plan_period_end
    stripe_current_period_end? ? stripe_current_period_end : Date.current.end_of_month
  end

  def legacy_count
    OdkSfLegacy::Submission.joins(import: {mapping: :user}).where(users: {id: id}).where( "odk_sf_legacy_submissions.created_at BETWEEN ? AND ?", plan_period_start, plan_period_end).count
  end

  def seconds_to_units(seconds)
  '%d days, %d hours, and %d minutes' %
    # the .reverse lets us put the larger units first for readability
    [24,60].reverse.inject([seconds]) {|result, unitsize|
      result[0,0] = result.shift.divmod(unitsize)
      result
    }
  end

  def reset_countdown
    seconds = (stripe_current_period_end? ? stripe_current_period_end : DateTime.current.end_of_month - DateTime.now) * 24 * 60
    seconds_to_units(seconds)
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