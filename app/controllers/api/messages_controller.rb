class Api::MessagesController < ApplicationController

  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login

  def create
    head :created
  end

end
