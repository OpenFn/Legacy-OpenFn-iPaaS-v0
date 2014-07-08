class MappingsController < ApplicationController

  before_action :load_mapping, only: [:show, :edit, :update, :destroy, :dispatch_surveys, :clone]

  def index
    @mappings = current_user.mappings.page params[:page]
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
    @mapping = current_user.mappings.new mapping_params
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
    unless params[:only].blank?
      only = params[:only].to_i

      if only > 0
        Resque.enqueue(OdkToSalesforce::Dispatcher, @mapping.id, only, current_user)
      end
    end
    redirect_to @mapping
  end

  def clone
    new_mapping = @mapping.dup :include => {salesforce_fields: :odk_fields}
    new_mapping.name = new_mapping.name + "_copy"
    if new_mapping.save
      redirect_to new_mapping
    else
      render :show
    end

  end

  protected

  def load_mapping
    @mapping = current_user.mappings.find params[:id]
  end

  def mapping_params
    params.require(:mapping).permit(:name, :odk_formid, :active,
      salesforce_fields_attributes: [:id, :object_name, :label_name, :field_name, :data_type, :perform_lookups, :_destroy,
        odk_fields_attributes: [:id, :field_name, :field_type, :_destroy]
      ]
    )
  end
end
