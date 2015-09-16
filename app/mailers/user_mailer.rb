class UserMailer < ActionMailer::Base
  default from: "authentication@openfn.org"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.reset_password_email.subject
  #
  def reset_password_email(user)
    @user = user
    @url  = edit_password_reset_url(user.reset_password_token)
    mail(:to => user.email,
         :subject => "Your Open[Fn] password has been reset")
  end

  def activation_needed_email(user)
    @user = user
    @url  = "https://www.openfn.org/users/#{user.activation_token}/activate"
    mail(:to => user.email,
         :subject => "Welcome to Open[Fn], activation link")
  end

  def activation_success_email(user)
    @user = user
    @url  = "https://www.openfn.org/login"
    mail(:to => user.email,
         :subject => "Your Open[Fn] account is now activated")
  end
end