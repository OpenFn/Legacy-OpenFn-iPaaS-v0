class HomeController < ApplicationController
  layout false

  skip_before_filter :require_login
  
  def index

  end
end
