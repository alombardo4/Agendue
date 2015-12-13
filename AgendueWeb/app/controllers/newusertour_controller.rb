class NewusertourController < ApplicationController
	def tour
		@user = User.find_by_id(session[:userid])
	end
end
