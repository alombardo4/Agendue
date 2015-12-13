class AdminController < ApplicationController
  # before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_filter :authorize, :admin
    def index
        user = User.find_by_id(session[:userid])
        if (user.name == "")
            @usercount = User.count
            @projectcount = Project.count
            @taskcount = Task.count
            @projectsperuser = @projectcount/@usercount
            @tasksperuser = @taskcount/@usercount

            @newtasks = Task.where('created_at > :week', {:week => 1.week.ago}).count
            @newprojects = Project.where('created_at > :week', {:week => 1.week.ago}).count

            @newusers = User.where('created_at > :week', {:week => 1.week.ago}).count

        else
            redirect_to projects_path
        end
    end

    def createpremiumoverride
        user = User.find_by_id(session[:userid])
        if (user.name == "")

        else
            redirect_to projects_path
        end
    end

    def showpremiumoverride
        @users = User.find_all_by_premiumoverride(true)
    end

    def addpremiumoverride
        user = User.find_by_id(session[:userid])
        if (user.name == "")
            emails = params[:useremail].split(',')
            emails.each do |email|
                email = email.downcase
                user = User.find_by_name(email)
                if user
                    if user.premiumoverride == true
                        user.premiumoverride = false
                    else
                        user.premiumoverride = true
                    end
                    flash[:alert] = "User " + email + " has been updated"
                    user.save!
                else
                    premUser = PremiumUser.find_by_name(email)
                    if !premUser
                        premUser = PremiumUser.new()
                        premUser.name = email
                        premUser.admin_init = true
                        premUser.save!
                    end
                    flash[:alert] = "Premium user " + email + " has been initialized"
                end
            end
            redirect_to request.referrer
        else
            redirect_to projects_path
        end
    end
end
