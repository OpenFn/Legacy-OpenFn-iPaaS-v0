require 'rails_helper'

RSpec.describe PasswordResetsController, :type => :controller do

  describe "GET create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET edit" do
    it "returns http success" do
      expect(User).to receive(:load_from_reset_password_token).with("999").and_return(double)
      get :edit, id: 999
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET update" do
    let(:user) { double }
    it "returns http success" do
      expect(User).to receive(:load_from_reset_password_token).with("999").and_return(user)
      expect(user).to receive(:password_confirmation=).with("xxx")
      expect(user).to receive(:change_password!).with("xxx").and_return(true)

      get :update, id: 999, user: {password_confirmation: "xxx", password: "xxx"}
      expect(response).to have_http_status(:redirect)
    end
  end

end
