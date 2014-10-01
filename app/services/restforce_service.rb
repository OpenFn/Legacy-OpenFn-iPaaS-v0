class RestforceService

  def initialize(user)
    @user = user
  end

  def connection
    Restforce.new({
      username: @user.sf_username,
      password: @user.sf_password,
      security_token: @user.sf_security_token,
      client_id: @user.sf_app_key,
      client_secret: @user.sf_app_secret,
      host: @user.sf_host
    })
  end

end