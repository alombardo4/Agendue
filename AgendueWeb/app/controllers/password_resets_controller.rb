class PasswordResetsController < ApplicationController
  def new
  end
  def create
  	@user = User.find_by_name(params[:name])
  	if @user
	  	newpass = SecureRandom.hex(6)
	  	@user.password = newpass
	  	@user.password_confirmation = newpass
	  	@user.save!
	  	Thread.new do
		  	reset_pass_params = {
		  		:name => @user.name,
		  		:password => newpass
		  	}
		  	UserMailer.password_reset(reset_pass_params).deliver
	    	ActiveRecord::Base.connection.close
	    end
	end
  	redirect_to login_url
  end
end
