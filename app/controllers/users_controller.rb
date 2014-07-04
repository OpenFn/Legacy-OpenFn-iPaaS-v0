class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      redirect_to(:root, notice: "Welcome!")
    else
      flash.now[:alert] = "Signup failed..."
      render(:new)
    end
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
  end


  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
