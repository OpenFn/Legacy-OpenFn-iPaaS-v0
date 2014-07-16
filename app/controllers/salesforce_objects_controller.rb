class SalesforceObjectsController < ApplicationController

  def index
    sf_client = Restforce.new(username: current_user.sf_username,
                              password: current_user.sf_password,
                              security_token: current_user.sf_security_token,
                              client_id: current_user.sf_app_key,
                              client_secret: current_user.sf_app_secret)
    render json: sf_client.describe.select{|d| d["custom"]}.collect{|d| {label: d["label"], name: d["name"]}}
  end

end
