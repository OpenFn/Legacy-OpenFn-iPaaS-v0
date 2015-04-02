module Api::V1
  class MappingsController < ApplicationController
    before_action :load_mapping, only: [:update]

    skip_before_filter :verify_authenticity_token

    # Making a new Mapping
    # --------------------
    # `POST /api/v1/mappings`
    #
    # Respond with new mapping.
    #

    def create
      @mapping = Mapping.create!(user_id: current_user.id)
      render json: @mapping
    end

    # Updating a Mapping
    # --------------------
    # `PUT /api/v1/mappings/id`
    #
    # Respond with the updated mapping.

    def update
      if @mapping.update mapping_params
        render json: @mapping
      else
        render json: {errors: @mapping.errors.full_messages}, status: 422
      end
    end

    private

    def load_mapping
      @mapping = Mapping.where(id: params[:id], user_id: current_user.id)
    end

    def mapping_params
      params.require(:mapping).permit(
        :name,
        :active,
        :enabled
      )
    end

  end
end
