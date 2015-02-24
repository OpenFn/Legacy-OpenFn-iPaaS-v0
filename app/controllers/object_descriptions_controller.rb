class ObjectDescriptionsController < ApplicationController
  before_action :set_connected_app
  before_action :get_description, only: [:show, :edit, :update]

  ##GET /connected_apps/:id/object_description/:identifier.json
  def show
  	render json: @object_description, include: :object_descriptors
  end

  ##GET /connected_apps/:id/object_descriptions/new
  def new
    @object_description = @connected_app.object_descriptions.new
    @object_descriptors = @object_description.object_descriptors.build if @object_description.object_descriptors.count.eql?(0)
  end

  ##POST /connected_apps/:id/object_descriptions
  def create
    object_description = @connected_app.object_descriptions.new(object_description_params)
    respond_to do |format|
      if object_description.save
        format.json { render json: object_description, status: :created }
      else
        format.json { render json: object_description.errors, status: :unprocessable_entity }
      end
    end
  end

  ##GET /connected_apps/:id/object_descriptions/:identifier/edit.json
  def edit
  	@object_descriptors = @object_description.object_descriptors.build if @object_description.object_descriptors.count.eql?(0)
  end

  ##PATCH /connected_apps/:id/object_description/:identifier.json
  def update
  	respond_to do |format|
      if object_description.update(object_description_params)
        format.json { render json: object_description, status: :created }
      else
        format.json { render json: object_description.errors, status: :unprocessable_entity }
      end
    end
  end

  ##DELETE /connected_apps/:id/object_description/:identifier
  def destroy
  	@object_description.destroy
  	respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    def set_connected_app
      @connected_app = ConnectedApp.find(params[:id])
    end

    def get_description
      @object_description = @connected_app.object_descriptions.find_by(identifier: params[:identifier])
    end

    def object_description_params
    	params.require(:object_description).permit(:connected_app_id, :identifier, :label, :meta, object_descriptors: [:object_description_id, :identifier, :label, :hidden, :meta])
    end
end
