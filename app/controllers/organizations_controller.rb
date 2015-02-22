class OrganizationsController < ApplicationController
  before_action :check_client_admin
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations.json
  def index
    @organizations = Organization.all
    render json: @organizations
  end

  # GET /organizations/:id.json
  def show
  	render json: @organization
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/:id/edit
  def edit
  end

  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.json { render json: @organization, status: :created }
      else
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/:id.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.json { head :no_content }
      else
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/:id.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # callbacks to share common setup between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Strong params
    def organization_params
      params.require(:organization).permit(:name, :credits, :plan_id)
    end
end
