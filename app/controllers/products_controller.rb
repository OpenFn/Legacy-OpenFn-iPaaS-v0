class ProductsController < ApplicationController
  respond_to :json
  layout false

  def index
    render json: Product.order('name').as_json
  end
end