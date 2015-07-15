class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def create
    if login(params[:email], params[:password])
      if session[:redirect_to_url]
        redirect_back_or_to(session[:redirect_to_url], notice: "Welcome Back!")
      else
        redirect_back_or_to('/marketplace', notice: "Welcome Back!")
      end
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to(:root, notice: 'You have logged out. Goodbye!')
  end

end