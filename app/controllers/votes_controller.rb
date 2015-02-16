class VotesController < ApplicationController

	def count
		render json: Vote.all
	end
	
end
