class DevicesController < ApplicationController
  before_filter :authorize
  before_action :set_device, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:create]

  # POST /devices
  # POST /devices.json
  def create
    if session[:userid]
      user = User.find(session[:userid])
      if user
        if !Device.find_by_token(device_params[:token])
          @device = Device.new(device_params)
          @device.save!
          puts @device.id
          if user.deviceids
            user.deviceids = user.deviceids + @device.id.to_s + ","
          else
            user.deviceids = @device.id.to_s + ","
          end
          user.save!
        end

      else
        redirect_to login_path
      end
    else
      redirect_to login_path
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:os, :token)
    end
end
