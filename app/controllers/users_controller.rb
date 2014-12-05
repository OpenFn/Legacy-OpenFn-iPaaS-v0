class UsersController < ApplicationController
  respond_to :html, :json, :xml
  skip_before_filter :require_login, only: [:new, :create, :sync]

  skip_before_filter :verify_authenticity_token, only: [:sync]
  before_filter :validate_api_admin, only: [:sync]

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

  # From SalesForce
  def sync
    notification = Salesforce::Notification.new(request.body.read)
    salesforce_user = Salesforce::Listing::UserListing.new(notification)

    user = User.find(salesforce_user.id)
    user.synced = true

    if user.update_attributes(salesforce_user.attributes)
      limiter = MappingLimiter.new(user)
      limiter.limit!
      
      respond_to do |format|
        format.xml  { render 'salesforce/success', layout: false }
      end
    else
      respond_to do |format|
        format.xml  { render xml: "", status: 422 }
      end
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
    params.require(:user).permit(
      :email, :password, :password_confirmation,
      :odk_url, :odk_username, :odk_password,
      :sf_security_token, :sf_username, :sf_password, :sf_app_key, :sf_app_secret, :sf_host
    )
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
      odk = OdkAggregate::Connection.new(@user.odk_url, @user.odk_username, @user.odk_password)
      odk.all_forms
      return true
    rescue
      return false
    end
  end

  def check_sf_credentials
    begin
      rf = RestforceService.new(@user).connection
      rf.describe
      return true
    rescue
      return false
    end
  end
end
