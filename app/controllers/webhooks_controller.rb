require 'json'
Stripe.api_key = Rails.configuration.stripe[:secret_key]

class WebhooksController < ApplicationController
	protect_from_forgery except: :receive_stripe_events
	skip_before_filter  :verify_authenticity_token, :require_login

	def receive_stripe_events
	  event = request.body.read
	  data_json = JSON.parse(event)
	  event_type = data_json['type']

	  case event_type
	  when "charge.succeeded"
	    update_subscription_period data_json
	  when "customer.subscription.deleted"
        subscription_deleted data_json
	  end
	  render nothing: true
	end

	def update_subscription_period data_json
	  customer_id =  data_json['data']['object']['customer']
	  begin
	 	customer = Stripe::Customer.retrieve(customer_id)
		if customer.present?
	      user = User.find_by_email(customer.email)
		  if user.present?
		    user.stripe_current_period_end = Time.at(customer.subscriptions.data[0].current_period_end)
			user.save
		  end
		end
	  rescue
	    return
	  end
	end

	def subscription_deleted data_json
	  customer_id =  data_json['data']['object']['customer']
	  begin
		customer = Stripe::Customer.retrieve(customer_id)
		if customer.present?
		  user = User.find_by(email: customer.email)
		  if user.present?
	        plan = Plan.find_by(name: 'Free')
	        user.update(plan_id: plan.try(:id))
	      end
		end
	  rescue
		return
	  end
	end
end