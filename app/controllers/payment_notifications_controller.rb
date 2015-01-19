class PaymentNotificationsController < ApplicationController

  protect_from_forgery except: :create
  # IPN from PayPal
  def create
    Rails.logger.info params.inspect
    Salesforce::Purchase.register!(params)
  end

  def success
    redirect_to edit_user_url(current_user), flash: {success: "Payment approved."}
  end

  def failure
    redirect_to edit_user_url(current_user), flash: {danger: "Payment was cancelled, or failed."}
  end
  
end
