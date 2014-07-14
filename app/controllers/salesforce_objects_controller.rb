class SalesforceObjectsController < ApplicationController

  def index
    sf_client = Restforce.new(username: current_user.sf_username,
                              password: current_user.sf_password,
                              security_token: current_user.sf_security_token)
    render json: sf_client.describe.select{|d| d["custom"]}.collect{|d| {label: d["label"], name: d["name"]}}
  end

end
