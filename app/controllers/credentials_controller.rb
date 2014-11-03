class CredentialsController < ApplicationController

  respond_to :json

  def index
    @credentials = Credential.all
    respond_with @credentials 
  end

end
