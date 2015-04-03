module Api::V1
  class ConnectionProfilesController < ApplicationController

    skip_before_filter :verify_authenticity_token

    def index
      type = params[:type] || "source"
      connection_profiles = AvailableConnectionProfiles.for(type, current_user.id)

      render json: connection_profiles
    end

    def create
      connection_profile = ConnectionProfile.new(connection_profile_params)
      if connection_profile.save
        render json: connection_profile, status: 201
      else
        render json: connection_profile.errors, status: 400
      end
    end

    def connected_apps
      connection_profile = ConnectionProfile.find(params[:id])
      descriptions = connection_profile.fetch_object_descriptions
      render json: descriptions
    end

    private

    def connection_profile_params
      params.require(:connection_profile).permit(:name, :product_id, :user_id, :type, :credential_id).merge(user_id: current_user.id)
    end

  end
end