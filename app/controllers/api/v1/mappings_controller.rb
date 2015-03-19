module Api::V1
  class MappingsController < ApplicationController

    skip_before_filter :verify_authenticity_token

    # Making a new Mapping
    # --------------------
    # `POST /api/v1/mappings`
    #
    # Respond with new mapping.

    def create
      @mapping = Mapping.create!(user_id: current_user.id)

      render json: @mapping
    end

  end
end
