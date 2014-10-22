class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :require_login
  # admin role implementation is very simple at present, since admin one has one page to view
  # and there's no overlap between roles. Implement proper permissions system once role expands.

  private

  def not_authenticated
    redirect_to login_path, alert: "Please login first"
  end
end
