class ConnectAppsController < ApplicationController
  before_action :set_connected_app, only: [:show, :edit, :update, :destroy]

  # GET /connected_apps.json
  def index
    @connected_apps = ConnectedApp.all
    render json: @connected_apps
  end

  # GET /connected_apps/:id.json
  def show
  	render json: @connected_app
  end

  # GET /connected_apps/new
  def new
    @connected_app = ConnectedApp.new
  end

  # GET /connected_apps/:id/edit
  def edit
  end

  # POST /connected_apps.json
  def create
    @connected_app = ConnectedApp.new(connected_app_params)

    respond_to do |format|
      if @connected_app.save
        format.json { render json: @connected_app, status: :created }
      else
        format.json { render json: @connected_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /connected_apps/:id.json
  def update
    respond_to do |format|
      if @connected_app.update(connected_app_params)
        format.json { head :no_content }
      else
        format.json { render json: @connected_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /connected_apps/:id.json
  def destroy
    @connected_app.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # callbacks to share common setup between actions.
    def set_connected_app
      @connected_app = ConnectedApp.find(params[:id])
    end

    # Strong params
    def connected_app_params
      params.require(:connected_app).permit(:name, :product_id, :user_id)
    end
end
