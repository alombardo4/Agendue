
class ChargesController < ApplicationController
  before_filter :authorize
  protect_from_forgery :except => [:create]

	def new
		redirect_to explainfeatures_path
		# if session[:userid]
		# 	@user = User.find_by_id(session[:userid])
		# 	if @user.currentSubscriber == true
		# 		redirect_to root_path
		# 	end
		# else
		# 	redirect_to root_path
		# end
	end

	def create
		redirect_to charges_path
	# 	if session[:userid]
	# 		#Amount in cents
	# 		@amount = 499
	# 		@user = User.find_by_id(session[:userid])
	# 		customer = Stripe::Customer.create(
	# 			:email	=> @user.name,
	# 			:card	=> params[:stripeToken],
	# 			:plan 	=> "Agendue1Mo"
	# 		)
	# 		@user.stripeid = customer.id
	# 		@user.currentSubscriber = true
	# 		@user.premium = true
	# 		@user.save! 
	# 	else
	# 		redirect_to root_path
	# 	end
	# rescue Stripe::CardError => e
	# 	flash[:error] = e.message
	# 	redirect_to charges_path
	end

	def explainfeatures
		if session[:userid]
			@user = User.find_by_id(session[:userid])
			if @user.currentSubscriber == true
				redirect_to root_path
			end
		else
			redirect_to root_path
		end
	end
end
