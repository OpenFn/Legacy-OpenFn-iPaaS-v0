class TagCategoriesController < ApplicationController

	def index
		categories = TagCategory.order('id ASC')
		render json: categories.to_json
	end

end