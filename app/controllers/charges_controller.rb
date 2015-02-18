class ChargesController < ApplicationController

def new
end

def create
  # Amount in cents
  @amount = 7900

  #Stu, we need to wrap this in a try catch to handle errors: https://stripe.com/docs/api#errors
  customer = Stripe::Customer.create(
    :email => 'example@stripe.com',
    :plan => "Startup",
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd'
  )

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to charges_path
end

end
