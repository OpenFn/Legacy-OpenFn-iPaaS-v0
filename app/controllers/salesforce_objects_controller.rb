class SalesforceObjectsController < ApplicationController

  def index
    #sf_client = Restforce.new
    #render json: sf_client.describe.select{|d| d["custom"]}.collect{|d| d["label"]}
    render json: ["Answer", "Question"]
  end

end