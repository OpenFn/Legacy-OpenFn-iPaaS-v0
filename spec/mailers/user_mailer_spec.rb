require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "reset_password_email" do
    let(:mail) { UserMailer.reset_password_email(user) }
    let(:user) { double(email: "to@example.org", reset_password_token: "123ABC", first_name: "John") }

    it "renders the headers" do
      expect(mail.subject).to eq("Your openfn.org password has been reset.")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["authentication@openfn.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
