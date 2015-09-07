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
         :subject => "Your openfn.org password has been reset.")
  end
  def welcome_email(user)
    @user = user
    @url = 'https://www.openfn.org/'
    mail(:to => user.email,
         :cc => "admin@openfn.org",
         :subject => "Let's get started!")
  end
end
