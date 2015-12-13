module ApplicationHelper
	def is_admin(name)
		user = User.find_by_id(session[:userid])
		(user.name == "")

	end

  def primary_color
    @color = "#3692d5"
    if session && session[:userid]
      user = User.find_by_id(session[:userid])
      if user && (user.premium == true || user.premiumoverride == true)
        if user.primary_color != nil && user.primary_color != ""
          @color = user.primary_color
        else
          @color = "#3692d5"
        end
      end
    elsif request.original_fullpath == project_show_public_path(params[:id])
      user = firstUser(Project.find_by_id(params[:id]))
      if user.primary_color != nil && user.primary_color != ""
        @color = user.primary_color
      else
        @color = "#3692d5"
      end
    end
    @color
  end

  def secondary_color
    @color = "#3692d5"
    if session && session[:userid]
      user = User.find_by_id(session[:userid])
      if user && (user.premium == true || user.premiumoverride == true)
        if user.secondary_color != nil && user.secondary_color != ""
          @color = user.secondary_color
        else
          @color = "#3692d5"
        end
      end
    elsif request.original_fullpath == project_show_public_path(params[:id])
      user = firstUser(Project.find_by_id(params[:id]))
      if user.secondary_color != nil && user.secondary_color != ""
        @color = user.secondary_color
      else
        @color = "#3692d5"
      end
    end
    @color
  end

  def tertiary_color
    @color = "#3692d5"
    if session && session[:userid]
      user = User.find_by_id(session[:userid])
      if user && (user.premium == true || user.premiumoverride == true)
        if user.tertiary_color != nil && user.tertiary_color != ""
          @color = user.tertiary_color
        else
          @color = "#3692d5"
        end
      end
    elsif request.original_fullpath == project_show_public_path(params[:id])
      user = firstUser(Project.find_by_id(params[:id]))
      if user.tertiary_color != nil && user.tertiary_color != ""
        @color = user.tertiary_color
      else
        @color = "#3692d5"
      end
    end
    @color
  end

  def firstUser(project)
    workers = Array.new()
    for shared in project.allshares.split(",")
      tempuser = User.find_by_id(shared)
      if tempuser
        workers << tempuser
      end
    end
    @user = workers[0]
  end
end
