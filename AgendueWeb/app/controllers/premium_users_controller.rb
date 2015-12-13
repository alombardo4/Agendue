class PremiumUsersController < ApplicationController
  before_filter :authorize, :admin
  before_action :set_premium_user, only: [:show, :edit, :update, :destroy]

  # GET /premium_users
  # GET /premium_users.json
  def index
    @premium_users = PremiumUser.all
  end

  # GET /premium_users/1
  # GET /premium_users/1.json
  def show
  end

  # GET /premium_users/new
  def new
    @premium_user = PremiumUser.new
  end

  # GET /premium_users/1/edit
  def edit
  end

  # POST /premium_users
  # POST /premium_users.json
  def create
    @premium_user = PremiumUser.new(premium_user_params)

    respond_to do |format|
      if @premium_user.save
        format.html { redirect_to @premium_user, notice: 'Premium user was successfully created.' }
        format.json { render action: 'show', status: :created, location: @premium_user }
      else
        format.html { render action: 'new' }
        format.json { render json: @premium_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /premium_users/1
  # PATCH/PUT /premium_users/1.json
  def update
    respond_to do |format|
      if @premium_user.update(premium_user_params)
        format.html { redirect_to @premium_user, notice: 'Premium user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @premium_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /premium_users/1
  # DELETE /premium_users/1.json
  def destroy
    @premium_user.destroy
    respond_to do |format|
      format.html { redirect_to premium_users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_premium_user
      @premium_user = PremiumUser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def premium_user_params
      params.require(:premium_user).permit(:name, :admin_init)
    end
end
