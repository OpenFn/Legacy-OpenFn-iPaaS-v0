require 'json'
Stripe.api_key = Rails.configuration.stripe[:secret_key]

class WebhooksController < ApplicationController
	skip_before_filter  :verify_authenticity_token, :authenticate_user!

	def receive_stripe_events
		event = request.body.read
		data_json = JSON.parse(event)
		event_type = data_json['type']

		case event_type
		when "charge.failed"
      charge_failed data_json
		end
		render nothing: true
	end

	def charge_failed data_json
		customer_id =  data_json['data']['object']['customer']
		charge_id = data_json['data']['object']['id']
		amount_pence = data_json['data']['object']['amount']
		amount = (amount_pence.to_f / 100)
		begin
			customer = Stripe::Customer.retrieve(customer_id)
			if customer.present?
			  span = customer.subscriptions.data[0].plan.interval
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