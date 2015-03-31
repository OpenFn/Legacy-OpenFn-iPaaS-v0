require 'openfn_odk/openfn_odk'
require 'openfn_salesforce/openfn_salesforce'

module Api::V1
  class CredentialsController < ApplicationController
    respond_to :json

    def index
      @credentials = Credential.all
      respond_with @credentials
    end

    def create
      type = credentials_params[:type]
      credential = Rails::Application.const_get(type).new(credentials_params)
      if credential.save
        credential.verify!
        render json: { credential: credential, valid: true }, status: 201
      else
        render json: { errors: credential.errors, valid: false }
      end
    end

    private

    def credentials_params
      params.require(:credential).permit(:username, :password, :url, :type,
        :security_token, :app_key, :app_secret, :host)
    end
  end
end
