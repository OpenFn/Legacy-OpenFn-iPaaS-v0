class TagCategoriesController < ApplicationController

	def index
		tags = Tag.all
		render json: tags.to_json
	end

end