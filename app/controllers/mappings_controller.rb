class MappingsController < ApplicationController

  before_action :load_mapping, only: [:show, :edit, :update, :destroy]
  #before_action :load_odk_forms, only: [:new, :edit]

  def index
    @mappings = Mapping.page params[:page]
  end

  def new
    @mapping = Mapping.new
    @mapping.odk_formid = params[:mapping][:odk_formid] if params[:mapping] && params[:mapping][:odk_formid]
  end

  def create
    @mapping = Mapping.new mapping_params
    if @mapping.save
      redirect_to @mapping
    else
      load_odk_forms
      render :new
    end
  end

  def update
    if @mapping.update mapping_params
      redirect_to @mapping
    else
      load_odk_forms
      render :edit
    end
  end

  def get_salesforce_fields

  end

  protected

  def load_mapping
    @mapping = Mapping.find params[:id]
  end

  def mapping_params
    params.require(:mapping).permit(:name, :odk_formid,
      odk_mapping_fields_attributes: [:id, :field_name, :field_type, :_destroy, :salesforce_mappings]
    )
  end
end
