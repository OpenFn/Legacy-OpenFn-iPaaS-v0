class ApiController < ApplicationController
  skip_before_filter :require_login
  skip_before_filter :verify_authenticity_token
  before_filter :validate_api_authentication
end