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
      render :new
    end
  end

  def update
    @user = current_user

    if @user.update_attributes(user_params)
      redirect_to(:root, notice: "Settings updated.")
    else
      flash.now[:alert] = "Settings could not be updated successfully."
      render :edit
    end
  end

  def destroy
  end

  def edit
    @user = current_user
  end

  def index
  end


  private

  def user_params
    params.require(:user).permit(:email, :password,
                                         :password_confirmation,
                                         :odk_url, :sf_security_token,
                                         :sf_username, :sf_password)
  end
end
