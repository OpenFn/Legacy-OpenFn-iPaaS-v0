class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def create
    if login(params[:email], params[:password])
      if current_user.mappings.present?
        redirect_to(:mappings, notice: "Welcome Back!")
      else
        redirect_to(root_path, notice: "Welcome Back!")
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
