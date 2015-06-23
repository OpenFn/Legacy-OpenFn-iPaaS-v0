class Admin::DraftsController < Admin::BaseAdminController
  before_filter :find_draft, :only => [:show, :update, :destroy]

  def index
    @drafts = Draftsman::Draft.includes(:item).order('updated_at DESC')
    render json: @drafts
  end

  def show
  end

  # Post draft ID here to publish it
  def update
    # Call `draft_publication_dependencies` to check if any other drafted records should be published along with this
    # `@draft`.
    @dependencies = @draft.draft_publication_dependencies

    # If you would like to warn the user about dependent drafts that would need to be published along with this one, you
    # would implement an `app/views/drafts/update.html.erb` view template. In that view template, you could list the
    # `@dependencies` and show a button posting back to this action with a name of `commit_publication`. (The button's
    # being clicked indicates to your application that the user accepts that the dependencies should be published along
    # with the `@draft`, thus avoiding orphaned records).
    if @dependencies.empty? || params[:commit_publication]
      @draft.publish!
      flash[:success] = 'The draft was published successfully.'
      redirect_to admin_drafts_path
    else
      # Renders `app/views/drafts/update.html.erb`
    end
  end

  # Post draft ID here to revert it
  def destroy
    # Call `draft_reversion_dependencies` to check if any other drafted records should be reverted along with this
    # `@draft`.
    @dependencies = @draft.draft_reversion_dependencies

    # If you would like to warn the user about dependent drafts that would need to be reverted along with this one, you
    # would implement an `app/views/drafts/destroy.html.erb` view template. In that view template, you could list the
    # `@dependencies` and show a button posting back to this action with a name of `commit_reversion`. (The button's
    # being clicked indicates to your application that the user accepts that the dependencies should be reverted along
    # with the `@draft`, thus avoiding orphaned records).
    if @dependencies.empty? || params[:commit_reversion]
      @draft.revert!
      flash[:success] = 'The draft was reverted successfully.'
      redirect_to admin_drafts_path
    else
      # Renders `app/views/drafts/destroy.html.erb`
    end
  end

private

  # Finds draft by `params[:id]`.
  def find_draft
    @draft = Draftsman::Draft.find(params[:id])
  end
end
