class ChargesController < ApplicationController

	skip_before_filter :require_login

	def new
	end

	def create
	  # Amount in cents
	  @amount = params[:amount]

	  customer = Stripe::Customer.create(
	  	:email => 'example@stripe.com',
	  	:card  => params[:token]
	  	)

	  begin
		  charge = Stripe::Charge.create(
		  	:customer    => customer.id,
		  	:amount      => @amount,
		  	:description => 'Rails Stripe customer',
		  	:currency    => 'usd'
		  	)

		  render :create

		rescue Stripe::CardError => e
			flash[:error] = e.message
			redirect_to root_path
		end
	end

end