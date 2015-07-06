module Api::V1
  class MappingsController < ApplicationController
    before_action :load_mapping, only: [:update, :show]

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
      @mapping.assign_attributes mapping_params
      if @mapping.save
        render json: @mapping
      else
        render json: {errors: @mapping.errors.full_messages}, status: 422
      end
    end

    # Fetching a Mapping
    # --------------------
    # `GET /api/v1/mappings/id`
    #
    # Respond with the mapping.

    def show
      if @mapping
        render json: @mapping
      else
        render json: null, status: 404
      end
    end

    private

    def load_mapping
      @mapping = Mapping.where(id: params[:id], user_id: current_user.id).first
    end

    def mapping_params
      params.require(:mapping).permit(
        :name,
        :active,
        :enabled,
        :source_connected_app_id,
        :destination_connected_app_id
      )
    end

  end
end
