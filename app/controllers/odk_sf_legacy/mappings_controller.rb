module OdkSfLegacy
  class MappingsController < ApplicationController
    before_action :load_mapping, only: [:show, :edit, :update, :destroy, :dispatch_surveys, :clone, :clear_cursor]
    before_action :ensure_valid_credentials, only: [:new, :show, :edit]

    def index
      @mappings = current_user.mappings.page params[:page]
      unless current_user.valid_credentials
        flash[:danger] = "Please add valid Salesforce and ODK
                         credentials in your settings."
      end
    end

    def show
      load_salesforce_objects

      respond_to do |format|
        format.html
        format.json {
          render json: {
            mapping: MappingSerializer.new(@mapping).as_json,
            salesforceObjects: @salesforce_objects
          }
        }
      end
    end

    def new
      @mapping = OdkSfLegacy::Mapping.new
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

    def destroy
      if @mapping.destroy
        redirect_to(mappings_url)
      else
        render(:show, notice: "Mapping could not be destoyed.")
      end
    end

    def dispatch_surveys
      if @mapping.enabled?
        unless params[:only].blank?
          only = params[:only].to_i

          if only > 0
            Sidekiq::Client.enqueue(OdkToSalesforce::Dispatcher, @mapping.id, only)
          end
        end
        redirect_to @mapping
      else
        redirect_to @mapping, notice: "Mapping must be enabled in order to import."
      end
    end

    def clone
      new_mapping = @mapping.duplicate
      if new_mapping.save
        redirect_to new_mapping
      else
        render :show
      end
    end

    def clear_cursor

      if @mapping.import
        @mapping.import.update(cursor: nil, last_uuid: nil)
      end

      redirect_to @mapping
    end

    protected

    def load_mapping
      @mapping = current_user.mappings.find params[:id]
    end

    def mapping_params
      params.require(:mapping).permit(
        :name,
        :active,
        :enabled,
        odk_form_attributes: [
          :name
        ]
      )
    end

    def load_salesforce_objects
      sf_client = RestforceService.new(current_user).connection
      @salesforce_objects = sf_client.describe.collect{|d| {label: d["label"], name: d["name"]}}.sort_by{|h| h[:label]}
    end

    def ensure_valid_credentials
      redirect_to odk_sf_legacy_mappings_path unless current_user.valid_credentials
    end
  end
end
