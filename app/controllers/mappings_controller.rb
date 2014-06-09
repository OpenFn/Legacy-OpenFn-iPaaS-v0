class MappingsController < ApplicationController

  before_action :load_mapping, only: [:show, :edit, :update, :destroy, :dispatch_surveys]

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
      render json: @mapping
    else
      render json: {errors: @mapping.errors.full_messages}, status: 422
    end
  end

  def dispatch_surveys
    only = params[:only].to_i
    only = 1 if params[:only].blank?
    puts "DISPATCHING #{only}, for #{@mapping}".yellow.bold
    Resque.enqueue OdkToSalesforce::Dispatcher, @mapping.id, only
    redirect_to @mapping
  end

  protected

  def load_mapping
    @mapping = Mapping.find params[:id]
  end

  def mapping_params
    params.require(:mapping).permit(:name, :odk_formid, :active,
      salesforce_fields_attributes: [:id, :object_name, :field_name, :data_type, :_destroy,
        odk_fields_attributes: [:id, :field_name, :field_type, :_destroy]
      ]
    )
  end
end
