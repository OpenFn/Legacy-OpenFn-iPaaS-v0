class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user = login(session_params[:email], session_params[:password])
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

  private

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
