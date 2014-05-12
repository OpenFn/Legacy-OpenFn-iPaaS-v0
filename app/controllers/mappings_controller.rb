class MappingsController < ApplicationController

  before_action :load_mapping, only: [:show, :edit, :update, :destroy]

  def index
    @mappings = Mapping.page params[:page]
  end

  def new
    @mapping = Mapping.new
    @mapping.odk_formid = params[:mapping][:odk_formid] if params[:mapping] && params[:mapping][:odk_formid]
    @mapping.salesforce_object_name = params[:mapping][:salesforce_object_name] if params[:mapping] && params[:mapping][:salesforce_object_name]
    load_odk_forms
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

  protected

  def load_mapping
    @mapping = Mapping.find params[:id]
  end

  def mapping_params
    params.require(:mapping).permit(:name, :odk_formid, :salesforce_object_name,
      mapping_fields_attributes: [:odk_field_name, :odk_field_type, :salesforce_object_field_name]
    )
  end

  def load_odk_forms
    @odk_forms = OdkAggregate::Form.all.collect(&:form_id).sort
    load_salesforce_forms
    load_odk_mapping_fields
  end

  def load_salesforce_forms
    client = Restforce.new
    @sf_forms = client.describe.select{|d| d["custom"]}.collect{|d| d["label"]}
    @sf_form_fields = []

    if params[:mapping] && !(object_name = params[:mapping][:salesforce_object_name]).blank?
      @sf_form_fields = client.describe("#{object_name}__c")["fields"].select{|f| f["updateable"]}.collect{|f| f["name"]}
    end

  end

  def load_odk_mapping_fields
    if params[:mapping] && params[:mapping][:odk_formid]
      OdkAggregate::Form.find(params[:mapping][:odk_formid]).fields.each do |field|
        unless @mapping.mapping_fields.detect{|f| f.odk_field_name.eql?(field["nodeset"])}
          @mapping.mapping_fields.build(
            odk_field_name: field["nodeset"],
            odk_field_type: field["type"]
          )
        end
      end
    end
  end

end
