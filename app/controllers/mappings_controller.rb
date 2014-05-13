class MappingsController < ApplicationController

  before_action :load_mapping, only: [:show, :edit, :update, :destroy]
  before_action :load_odk_forms, only: [:new, :edit]

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
    sf_client = Restforce.new
    @sf_fields = []

    unless (@object_name = params[:salesforce_object_name]).blank?
      @sf_fields = sf_client.describe("#{@object_name}__c")["fields"].select{|f| f["updateable"]}.collect{|f| f["name"]}
    end
  end

  protected

  def load_mapping
    @mapping = Mapping.find params[:id]
  end

  def mapping_params
    params.require(:mapping).permit(:name, :odk_formid,
      odk_mapping_fields_attributes: [:field_name, :field_type, :salesforce_mappings]
    )
  end

  def load_odk_forms
    @odk_forms = OdkAggregate::Form.all.collect(&:form_id).sort
    load_odk_mapping_fields
    load_salesforce_forms
  end

  def load_salesforce_forms
    sf_client = Restforce.new
    @sf_forms = sf_client.describe.select{|d| d["custom"]}.collect{|d| d["label"]}
  end

  def load_odk_mapping_fields
    if params[:mapping] && params[:mapping][:odk_formid]
      OdkAggregate::Form.find(params[:mapping][:odk_formid]).fields.each do |field|
        unless @mapping.odk_mapping_fields.detect{|f| f.field_name.eql?(field["nodeset"])}
          @mapping.odk_mapping_fields.build(
            field_name: field["nodeset"],
            field_type: field["type"]
          )
        end
      end
    end
  end

end
