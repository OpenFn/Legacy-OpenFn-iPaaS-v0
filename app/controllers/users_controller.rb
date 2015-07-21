class UsersController < ApplicationController
  respond_to :html, :json, :xml
  skip_before_filter :require_login, only: [:new, :create, :sync, :set_password, :check_login, :check_plan]

  skip_before_filter :verify_authenticity_token, only: [:sync]
  before_filter :validate_api_admin, only: [:sync]

  def new
    @user = User.new
    redirect_to "/register"
  end

  def create
    #@user = User.new(user_params)
    @user = User.new
    @user.email = params[:email]
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.organisation = params[:organisation]
    @user.save

    # respond_to do |format|
    #   if @user.save
    #     format.json { render json: @user, status: :created }
    #   else
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end

    # if @user.save_with_payment(params)
    #   auto_login(@user)
    #   set_user_credentials_and_flash
    #   redirect_to(:root, notice: "Welcome!")
    # else
    #   flash.now[:alert] = "Signup failed..."
    render :new
    # end
  end

  def index
    @users = User.all
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def update
    @user = current_user
    # if params[:organization_name] != @user.organization.try(:name)
    #   @user.organization.update(name: params[:organization_name])
    # end

    # respond_to do |format|
    #   if @user.update(user_params)
    #     format.json { head :no_content }
    #   else
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end

    # Ankur, I'm not sure if this is related.
    if @user.update(user_params)
      if @user.update_plan(params)
        set_user_credentials_and_flash
        flash[:success] = "Settings updated." unless flash[:danger]
        redirect_to(:edit_user)
      else
        flash.now[:danger] = "Settings could not be updated successfully."
        render :edit
      end
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

  def show
    render json: @user
  end

  def edit
    @user = current_user
    set_user_credentials_and_flash
  end

  # DELETE /organizations/:id.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def check_login
    if !current_user.present?
       session[:redirect_to_url] = params[:redirect]
       render json: {status: "login", redirect_url: "/login"}
       return
    else
      render :nothing => true, :status => 200
    end
  end

  def check_plan
    @value=nil
    if current_user.present?
      @value= current_user.plan.try(:name)
    end

    render json: @value
  end


  # def send_invite
  #   exsiting_user = User.find_by(email: params[:email])
  #   if exsiting_user.blank?
  #     password = SecureRandom.hex
  #     invite_token = SecureRandom.urlsafe_base64
  #     user = User.new(email: params[:email], crypted_password: password, salt: password, invitation_token: invite_token, organization_id: current_user.organization_id, role: 'client')
  #     user.save(validate: false)
  #     @success = true
  #   else
  #     @message = 'User already exist'
  #   end
  # end

  # def set_password
  #   if request.post?
  #     user = User.find_by(invitation_token: params[:token])
  #     user.password = params[:user][:password]
  #     user.password_confirmation = params[:user][:password]
  #     user.invitation_token = nil
  #     if user.save(validate: false)
  #       auto_login(user)
  #       flash[:success] = "Password updated." unless flash[:danger]
  #       redirect_to edit_user_path(user)
  #     else
  #       flash.now[:danger] = "Password could not be updated successfully."
  #       render :set_password
  #     end
  #   else
  #     if params[:token].present?
  #       @user = User.find_by(invitation_token: params[:token])
  #       unless @user.present?
  #         flash.now[:alert] = "Invalid Invitation Token!"
  #         redirect_to root_path and return
  #       end
  #     else
  #       flash.now[:alert] = "Invalid Url!"
  #       redirect_to root_path
  #     end
  #   end
  # end



  private

  def user_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :first_name, :last_name, :organisation, :role, :plan_id,
      # :invitation_token, :organization_id,
      :odk_url, :odk_username, :odk_password, :stripe_token, :subscription_plan, :stripe_coupon,
      :sf_security_token, :sf_username, :sf_password, :sf_app_key, :sf_app_secret, :sf_host
    )
  end

  def set_user_credentials_and_flash
    odk = check_odk_credentials
    sf = check_sf_credentials

    if odk && sf
      @user.update_attributes({valid_credentials: true})
    elsif sf
      @user.update_attributes({valid_credentials: false}) if @user.valid_credentials
      flash[:danger] = "Your ODK URL is not valid."
    elsif odk
      @user.update_attributes({valid_credentials: false}) if @user.valid_credentials
      flash[:danger] = "Your Salesforce credentials are not valid."
    else
      @user.update_attributes({valid_credentials: false})
      flash[:danger] = "Invalid ODK and Salesforce credentials"
    end
  end

  def check_odk_credentials
    begin
      odk = OdkAggregate::Connection.new(@user.odk_url, @user.odk_username, @user.odk_password)
      odk.all_forms
      return true
    rescue => e
      Rails.logger.info "ODK Credential check failed with:\n#{e.backtrace.join("\n")}"
      return false
    end
  end

  def check_sf_credentials
    begin
      rf = RestforceService.new(@user).connection
      rf.describe
      return true
    rescue => e
      Rails.logger.info "Salesforce Credential check failed with:\n#{e.backtrace.join("\n")}"
      return false
    end
  end

end