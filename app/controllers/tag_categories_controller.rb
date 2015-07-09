class TagCategoriesController < ApplicationController

	skip_before_filter :require_login

	def index
		categories = TagCategory.order('id ASC')
		render json: categories.to_json
	end

end