class HomeController < ApplicationController
	def home
		if User.find_by_id(session[:userid]) != nil 
	  		@loggedin = true
	  		redirect_to landing_path
	  	else
	  		@loggedin = false
	  		respond_to do |format|
	  			format.html
	  			format.mobile
	  		end
	  	end
	end
end
