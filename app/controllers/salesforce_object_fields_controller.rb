class SalesforceObjectFieldsController < ApplicationController

  def index


    render json: sf_fields, root: false
  end
end
