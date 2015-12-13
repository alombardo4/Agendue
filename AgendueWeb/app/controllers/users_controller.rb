class UsersController < ApplicationController
  skip_before_filter :authorize
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if session[:userid] != nil
        @user = User.find_by_id(session[:userid])
    else
      redirect_to login_url
    end
    # @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find_by_id(session[:userid])
    if session[:userid] != nil
      if @user.id == session[:userid]

        @taskscount = Task.all_tasks(@user.id).count
      else
        redirect_to projects_path
      end
    else
      redirect_to login_path
    end
    respond_to do |format|
      format.html
      format.mobile
      format.json
    end
    #redirect_to login_url
  rescue Stripe::InvalidRequestError => e
    @time = 0
    @date = nil
  end

  # GET /users/new
  def new
    if session[:userid] != nil
      redirect_to projects_path
    else
      @user = User.new
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by_id(session[:userid])
    if @user
      @issubscribed = @user.premium
    else
      redirect_to projects_path
    end
  end

  # POST /users
  # POST /users.json
  def create

    @user = User.new(user_params)

    premUser = PremiumUser.find_by_name(@user.name)
    if premUser
      @user.premiumoverride = true
      premUser.destroy!
    end

    # newuid = 0
    # for user in User.all
    #   if Integer(user.userid) > newuid
    #     newuid = Integer(user.userid)
    #   end
    # end
    @user.projectids = ""
    @user.name = @user.name.downcase
    # @user.userid = String(newuid + 1)
    respond_to do |format|
      if @user.save
        Thread.new do
          params = {
            :name => @user.name,
            :password => user_params[:password]
          }
          UserMailer.welcome_email(@user).deliver
          ActiveRecord::Base.connection.close
        end
        session[:userid] = @user.id
        format.html { redirect_to tour_path }
        format.json { render action: 'show', status: :created, location: @user }
      else
        flash[:error] = "The account could not be created"
        format.html { render action: 'new', error: "The account could not be created" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #redirect_to login_url
      if @user.update(user_params)
        if params[:reset_colors] == "1"
          @user.primary_color = nil
          @user.secondary_color = nil
          @user.tertiary_color = nil
          @user.save!
        end
        if @user.cancelPremium == true
          @cancancel = true
          pids = @user.projectids.split(",")
          for pid in pids
            project = Project.find_by_id(pid)
            if project
              teammateids = project.allshares.split(",")
              teammates = 0
              for teammate in teammateids
                if User.find_by_id(teammate)
                  teammates = teammates + 1
                end
              end
              if teammates > 5
                @cancancel = false
              end
            end
          end
          Stripe.api_key = Rails.configuration.stripe[:secret_key]
          if @user.stripeid
            cu = Stripe::Customer.retrieve(@user.stripeid)
            cu.cancel_subscription(at_period_end: true)
          end
          @user.cancelPremium = false
          @user.currentSubscriber = false


          @user.save!
          flash[:alert] = "Saved successfully! You have unsubscribed from Agendue Plus"
          if @cancancel
            redirect_to user_path(@user)
          else
            flash[:error] = "You have projects that require an Agendue Plus subscription. When your subscription expires, you will be automatically removed from them."
            redirect_to user_path(@user)
          end

        else
          if request.referrer && URI(request.referrer).path == oauthpassword_path
            redirect_to tour_path
          else
            flash[:alert] = "Saved successfully!"
            redirect_to user_path(@user)
          end
        end
      else
        format.html { render action: 'edit' }
        format.mobile { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
  rescue Stripe::InvalidRequestError => e
    @user.save!
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    redirect_to login_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by_id(params[:id])
      if !@user
        @user = User.find_by_id(session[:userid])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:firstname, :lastname, :name, :password, :password_confirmation, :userid, :projectids, :premium, :currentSubscriber, :noemail, :cancelPremium, :primary_color, :secondary_color, :tertiary_color, :reset_colors, :share_calendar)
    end
end
