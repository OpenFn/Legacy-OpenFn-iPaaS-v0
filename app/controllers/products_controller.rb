class ProductsController < ApplicationController
  respond_to :json
  layout false

  skip_before_filter :verify_authenticity_token, :require_login

  def index
    render json: Product.order('name').as_json
  end

  def update
    raise request.body.read

    respond_to do |format|
      format.xml  { render xml: "" }
    end
  end
end