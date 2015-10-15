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
                    :logo_url => @draft.object['logo_url'],
                    :description => @draft.object['description'],
                    :website => @draft.object['website'],
                    :enabled => @draft.object['enabled'],
                    :integrated => @draft.object['integrated'],
                    :costs => @draft.object['costs'],
                    :resources => @draft.object['resources'],
                    :detailed_description => @draft.object['detailed_description'],
                    :integration_type => @draft.object['integration_type'],
                    :tech_specs => @draft.object['tech_specs'],
                    :twitter => @draft.object['twitter'],
                    :email => @draft.object['email'],
                    :draft_id => nil,
                    :published_at => Time.now,
                    :trashed_at => nil)
      @draft.destroy
      render json: record
    end
    if @draft.event.eql?("create") and @draft.item_type.eql?("Product")
      schema = @draft.item_type.constantize
      record = schema.find(@draft.object['id'])
      record.update(:enabled => true,
                    :draft_id => nil,
                    :published_at => Time.now,
                    :trashed_at => nil)
      record.save
      @draft.destroy
      render json: record
    end
  end

  # Post draft ID here to revert it
  def destroy
    @draft.revert!
    render json: @draft
  end

private

  # Finds draft by `params[:id]`.
  def find_draft
    @draft = Draftsman::Draft.find(params[:id])
  end
end
