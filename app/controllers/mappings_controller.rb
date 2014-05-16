class MappingsController < ApplicationController

  before_action :load_mapping, only: [:show, :edit, :update, :destroy]

  def index
    @mappings = Mapping.page params[:page]
  end

  def show
    respond_to do |format|
      format.html
      format.json {
        render json: @mapping
      }
    end
  end

  def new
    @mapping = Mapping.new
  end

  def create
    @mapping = Mapping.new mapping_params
    if @mapping.save
      render json: @mapping
    else
      render json: {errors: @mapping.errors.full_messages}, status: 422
    end
  end

  def update
    if @mapping.update mapping_params
      redirect_to @mapping
    else
      render :edit
    end
  end

  protected

  def load_mapping
    @mapping = Mapping.find params[:id]
  end

  def mapping_params
    params.require(:mapping).permit(:name, :odk_formid,
      salesforce_fields_attributes: [:id, :object_name, :field_name,
        odk_fields_attributes: [:id, :field_name, :field_type]
      ]
    )
  end
end
