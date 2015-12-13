require 'gcm'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  def sendPushNotification(deviceToken, message, deviceOS)
    if deviceOS == "ios"
      # APNS.host = 'gateway.sandbox.push.apple.com'
      APNS.host = 'gateway.push.apple.com'

      # APNS.pem = '/var/www/dev.agendue.com/devcert.pem'
      APNS.pem = '/var/www/agendue.com/APNSProdCert.pem'
      APNS.port = 2195
      APNS.send_notification(deviceToken, message )
    elsif deviceOS == "android"
      gcm = GCM.new("AIzaSyAT6Hxi2_xpOYfekoy_uDuLg2oWhA8vQ_o")
      registration_id = Array.new()
      registration_id << deviceToken
      options = {
        'data' => {
          'message' => message
        }
      }
      response = gcm.send_notification(registration_id, options)
      Rails.logger.info response
    end
  end



  # protect_from_forgery with: :exception
    def handle_mobile
      request.format = :mobile if mobile_user_agent?
    end
    def mobile_user_agent?
        request.env["HTTP_USER_AGENT"].try :match, /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i
    end
    def set_no_cache
      response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
      response.headers["Pragma"] = "no-cache"
      response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    end
  protected
    def admin
      user = User.find_by_id(session[:userid])
      unless (user.name == "")
        flash[:error] = "You are not authorized to access that page"
        redirect_to root_path, error: "You are not authorized to access that page"
      end
    end
    def authorize
  		unless User.find_by_id(session[:userid])
        flash[:error] = "Please sign in"
  			redirect_to login_url, error: "Please sign in"
  		end
  	end

    def premium
      unless User.find_by_id(session[:userid]).premium == true || User.find_by_id(session[:userid]).premiumoverride
        flash[:error] = "You need Agendue for Business to access this page"
        redirect_to explainfeatures_path
      end
    end

    def on_project
      pids = User.find_by_id(session[:userid]).projectids.split(",");
      @project = Project.find_by_id(params[:id])

      unless pids.include? String(@project.id)
        flash[:error] = "You don't have access to this project"
        redirect_to projects_path
      end
    end

end
