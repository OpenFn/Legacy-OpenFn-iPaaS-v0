class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login
  # admin role implementation is very simple at present, since admin one has one page to view
  # and there's no overlap between roles. Implement proper permissions system once role expands.

  private

  def not_authenticated
    respond_to do |format|
      format.html { redirect_to login_path, alert: "Please login first" }
      format.json { head :unauthorized }
    end
  end

  def validate_api_authentication
    @api_key = ApiKey.find_by_access_token(params[:token])
    head :unauthorized unless @api_key
  end

  def validate_api_admin
    validate_api_authentication unless @api_key
    head :unauthorized unless @api_key.try(:admin?)
  end
end



# HTTP Header Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"