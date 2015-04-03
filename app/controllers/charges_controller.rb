class ChargesController < ApplicationController

	skip_before_filter :require_login

	def new
	end

	def create
		puts '@@@@@@@@@@@@@'
		puts '@@@@@@@@@@@@@'
		puts params
		puts '@@@@@@@@@@@@@'
		puts '@@@@@@@@@@@@@'

	  # Amount in cents
	  @amount = charges_params[:amount]

	  customer = Stripe::Customer.create(
	  	:email => 'example@stripe.com',
	  	:card  => charges_params[:token]
	  	)

	  begin
		  charge = Stripe::Charge.create(
		  	:customer    => customer.id,
		  	:amount      => @amount,
		  	:description => 'Rails Stripe customer',
		  	:currency    => 'usd'
		  	)

			puts 'DIDNT ERROR!'

		  redirect_to root_path

		rescue Stripe::CardError => e
			puts 'ERRORED!'
			flash[:error] = e.message
			redirect_to charges_path
		end
	end

	private

	def charges_params
		params.require(:charges).permit(:token, :amount)
	end
end