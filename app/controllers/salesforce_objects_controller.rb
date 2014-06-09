class SalesforceObjectsController < ApplicationController

  def index
    sf_client = Restforce.new
    render json: sf_client.describe.select{|d| d["custom"]}.collect{|d| {label: d["label"], name: d["name"]}}
  end

end