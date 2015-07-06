class Admin::DraftsController < Admin::BaseAdminController
  before_filter :find_draft, :only => [:show, :update, :destroy]

  def index
    @drafts = Draftsman::Draft.includes(:item).order('updated_at DESC')
    render json: @drafts
  end

  def new
    @draft = Draftsman::Draft.new
  end

  # Post draft ID here to publish it
  def update
    if @draft.event.eql?("update") and @draft.item_type.eql?("Product")
      schema = @draft.item_type.constantize
      record = schema.find(@draft.object['id'])
      record.update(:id => @draft.object['id'],
                    :name => @draft.object['name'],
                    :description => @draft.object['description'],
                    :salesforce_id => @draft.object['salesforce_id'],
                    :website => @draft.object['website'],
                    :enabled => @draft.object['enabled'],
                    :integrated => @draft.object['integrated'],
                    :costs => @draft.object['costs'],
                    :resources => @draft.object['resources'],
                    :provider => @draft.object['provider'],
                    :detailed_description => @draft.object['detailed_description'],
                    :update_link => @draft.object['update_link'],
                    :integration_type => @draft.object['integration_type'],
                    :detail_active => @draft.object['detail_active'],
                    :tech_specs => @draft.object['tech_specs'],
                    :sf_link => @draft.object['sf_link'],
                    :twitter => @draft.object['twitter'],
                    :email => @draft.object['email'],
                    :facebook => @draft.object['facebook'],
                    :draft_id => nil,
                    :published_at => Time.now,
                    :trashed_at => nil)
      @draft.destroy
      render json: record
    end
    if @draft.event.eql?("create") and @draft.item_type.eql?("Tagging")
      schema = @draft.item_type.constantize
      record = schema.find(@draft.object['id'])
      record.update(:draft_id => nil, :published_at => Time.now)
      @draft.destroy
      render json: record
    end
    if @draft.event.eql?("destroy") and @draft.item_type.eql?("Tagging")
      schema = @draft.item_type.constantize
      record = schema.find(@draft.object['id'])
      record.destroy
      @draft.destroy
      render json: record
    end

  end

  # Post draft ID here to revert it
  def destroy
    if @draft.event.eql?("destroy") and @draft.item_type.eql?("Tagging")
      schema = @draft.item_type.constantize
      record = schema.find(@draft.object['id'])
      record.update(:draft_id => nil, :trashed_at => nil)
      @draft.destroy
      render json: record
      return
    end
    @draft.revert!
    render json: @draft
  end

private

  # Finds draft by `params[:id]`.
  def find_draft
    @draft = Draftsman::Draft.find(params[:id])
  end
end
