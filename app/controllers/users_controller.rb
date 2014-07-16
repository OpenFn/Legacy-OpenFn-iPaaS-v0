class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      auto_login(@user)
      set_user_credentials_and_flash
      redirect_to(:root, notice: "Welcome!")
    else
      flash.now[:alert] = "Signup failed..."
      render :new
    end
  end

  def update
    @user = current_user

    if @user.update_attributes(user_params)
      set_user_credentials_and_flash
      flash[:success] = "Settings updated." unless flash[:danger]
      redirect_to(:edit_user)
    else
      flash.now[:danger] = "Settings could not be updated successfully."
      render :edit
    end
  end

  def destroy
  end

  def edit
    @user = current_user
    set_user_credentials_and_flash
  end

  def index
  end


  private

  def user_params
    params.require(:user).permit(:email, :password,
                                         :password_confirmation,
                                         :odk_url, :sf_security_token,
                                         :sf_username, :sf_password,
                                         :sf_app_key, :sf_app_secret,
                                         :odk_username, :odk_password)
  end

  def set_user_credentials_and_flash
    odk = check_odk_credentials
    sf = check_sf_credentials

    if odk && sf
      @user.update_attributes({valid_credentials: true}) unless @user.valid_credentials
    elsif sf
      @user.update_attributes({valid_credentials: false}) if @user.valid_credentials
      flash[:danger] = "Your ODK URL is not valid."
    elsif odk
      @user.update_attributes({valid_credentials: false}) if @user.valid_credentials
      flash[:danger] = "Your Salesforce credentials are not valid."
    else
      @user.update_attributes({valid_credentials: false}) if @user.valid_credentials
      flash[:danger] = "Invalid ODK and Salesforce credentials"
    end
  end

  def check_odk_credentials
    begin
      odk = OdkAggregate::Connection.new(@user.odk_url)
      odk.all_forms 
      return true
    rescue
      return false 
    end
  end

  def check_sf_credentials
    begin
      rf = Restforce.new(username: @user.sf_username,
                          password: @user.sf_password,
                          security_token: @user.sf_security_token,
                          client_id: @user.sf_app_key,
                          client_secret: @user.sf_app_secret)
      rf.describe
      return true
    rescue
      return false
    end
  end
end
