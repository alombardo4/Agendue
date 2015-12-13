class SessionsController < ApplicationController
  skip_before_filter :authorize
  def new
    if session[:userid]
      redirect_to landing_path
    end
  end

  def create
  	# user = User.find_by_name(params[:name].downcase)
    #oauth check
    auth_hash = request.env['omniauth.auth']
    if auth_hash
      if auth_hash[:proivider] == "facebook"
        user = User.find_by_name(auth_hash['extra']['raw_info']['email'].downcase)
        if user
          user.facebook = auth_hash.uid
          # render :text => 'success'
          session[:userid] = user.id
          user.save!
          redirect_to landing_path
        else
          # render :text => 'no user'
          user = User.new()
          user.name = auth_hash['extra']['raw_info']['email'].downcase
          user.firstname = auth_hash['extra']['raw_info']['first_name']
          user.lastname = auth_hash['extra']['raw_info']['last_name']
          user.premium = false
          user.currentSubscriber = false
          user.stripeid = nil
          pwd = SecureRandom.hex(6)
          user.password = pwd
          user.password_confirmation = pwd
          user.projectids = ""
          user.facebook = auth_hash.uid
          user.save!
          session[:userid] = user.id
          redirect_to oauthpassword_path
        end
      elsif auth_hash[:provider] = "google_oauth2"
        user = User.find_by_name(auth_hash[:info][:email].downcase)
        if user
          user.google_picture = auth_hash[:info][:image]
          # render :text => 'success'
          session[:userid] = user.id
          user.save!
          redirect_to landing_path
        else
          # render :text => 'no user'
          user = User.new()
          user.name = auth_hash[:info][:email].downcase
          user.firstname = auth_hash[:info][:first_name]
          user.lastname = auth_hash[:info][:last_name]
          user.premium = false
          user.currentSubscriber = false
          user.stripeid = nil
          pwd = SecureRandom.hex(6)
          user.password = pwd
          user.password_confirmation = pwd
          user.projectids = ""
          user.google_picture = auth_hash[:info][:image]
          user.save!
          session[:userid] = user.id
          redirect_to oauthpassword_path
        end
      else
        flash[:error] = "Invalid OAuth keys"
        redirect_to login_url
      end
    else
      user = User.find_by_name(params[:name].downcase)
      if user and user.authenticate(params[:password])
        session[:userid] = user.id

        user.save!
        redirect_to landing_path
      else
        flash[:error] = "Invalid user/password combination"
        redirect_to login_url, error: "Invalid user/password combination"
      end
    end

    if user && user.premiumoverride == true
      user.premium = true
      user.save!
    elsif user && user.premiumoverride == false
      user.premium = false
      user.primary_color = nil
      user.secondary_color = nil
      user.tertiary_color = nil
      user.save!
    end



    # if user.stripeid == nil || Stripe::Customer.retrieve(user.stripeid).subscription == nil
    #   # user.premium = false
    #   user.currentSubscriber = false
    # else
    #   periodend = Stripe::Customer.retrieve(user.stripeid).subscription.current_period_end
    #   current = Time.now.to_i
    #   if current > periodend
    #     user.premium = false
    #   end
    # end



  rescue NoMethodError => e
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      session[:userid] = user.id
      user.stripeid = nil
      # user.premium = false
      user.save!
      redirect_to root_path, data_no_turbolink: 'true'
    else
      redirect_to login_url, error: "invalid user/password combination"
    end
  rescue Stripe::InvalidRequestError => e
    user = User.find_by_name(params[:name])
    if user and user.authenticate(params[:password])
      session[:userid] = user.id
      user.stripeid = nil
      # user.premium = false
      user.save!
      redirect_to root_path, data_no_turbolink: 'true'
    else
      redirect_to login_url, error: "invalid user/password combination"
    end
  end

  def destroy
  	session[:userid] = nil
  	redirect_to root_path
  end

  def oauthpassword
    if session[:userid]
      @user = User.find_by_id(session[:userid])
    else
      redirect_to login_path
    end
  end
end
