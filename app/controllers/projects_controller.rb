class ProjectsController < ApplicationController
  before_action :check_client_admin
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects.json
  def index
    @projects = Project.all
    render json: @projects
  end

  # GET /projects/:id.json
  def show
  	render json: @project
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/:id/edit
  def edit
  end

  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.json { render json: @project, status: :created }
      else
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/:id.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.json { head :no_content }
      else
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/:id.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # callbacks to share common setup between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Strong params
    def project_params
      params.require(:project).permit(:organization_id)
    end
end
