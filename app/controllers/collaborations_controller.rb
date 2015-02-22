class CollaborationsController < ApplicationController
  before_action :set_project
  before_action :check_client_admin

  # GET /projects/:project_id/collaborations/new.json
  def new
    @collaboration = @project.collaborations.new
  end

  # POST /projects/:project_id/collaborations.json
  def create
    @collaboration = @project.collaborations.new(collaboration_params)
    respond_to do |format|
      if @collaboration.save
        format.json { render json: @collaboration, status: :created }
      else
        format.json { render json: @collaboration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/:project_id/collaborations/:id.json
  def update
    @collaboration = @project.collaborations.find(params:id)
    respond_to do |format|
      if @collaboration.update(collaboration_params)
        format.json { head :no_content }
      else
        format.json { render json: @collaboration.errors, status: :unprocessable_entity }
      end
    end
  end

  #DELETE /projects/:project_id/collaborations/:id.json
  def destroy
    @project.collaborations.find(params[:id]).destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # callbacks to share common setup between actions.
  	def set_project
  	  @project = Project.find(params[:project_id])
    end

    # Strong params
    def collaboration_params
      params.require(:collaboration).permit(:user_id)
    end
end
