class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def create
    if login(params[:email], params[:password])
      redirect_to(:root, notice: "Welcome Back!")
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
