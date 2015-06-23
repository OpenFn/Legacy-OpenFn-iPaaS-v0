class Admin::ProductsController < Admin::BaseAdminController
   before_filter :find_widget,  :only => [:show, :edit, :update, :destroy]
   #before_filter :reify_widget, :only => [:show, :edit]

   def index
    # The `live` scope gives us widgets that aren't in the trash.
    # It's also strongly recommended that you eagerly-load the `draft` association via `includes` so you don't keep
    # hitting your database for each draft.
    @products = Product.live.includes(:draft).order(:name)
    render json: @products
  end

  def new
    @product = Product.new
  end

  def show
    @product = Product.live.find(params[:id])
    Rails.logger.info {"#{__FILE__}:#{__LINE__} @product => #{@product}"}
    render json: @product
  end

  private

  # Finds non-trashed widget by `params[:id]`
  def find_widget
    @product = Product.live.find(params[:id])
  end

  # If the widget has a draft, load that version of it
  def reify_widget
    @product = @product.draft.reify if @product.draft?
  end

  # Strong parameters in Rails 4+
  def widget_params
    params.require(:product).permit(:title)
  end

end
