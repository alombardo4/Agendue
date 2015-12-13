class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_filter :authorize
  skip_before_filter :authorize, :only => [:show_public, :show]
  protect_from_forgery :except => [:destroy]
  before_filter :premium, :only => [:copy_options, :copy_start, :copy_run, :analytics]
  before_filter :has_access_to_project, :except => [:new, :index, :show, :show_public, :create, :copy_start]
  # GET /projects
  # GET /projects.json
  def index
    @user = User.find_by_id(session[:userid])
    @projects =  current_user_projects
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def shares
    @project = nil
    if params[:id]
      @project = Project.find_by_id(params[:id])
    else
      @project = Project.find_by_id(session[:lastproj])
    end
    @user = User.find_by_id(session[:userid])
    @workers = Project.workers_for_project(@project.id)

  end

  def canshare
    #DEPRECATED
  end
  # GET /projects/1
  # GET /projects/1.json
  def show
    tempproject = Project.find(params[:id])
    user = User.find_by_id(session[:userid])
    if !user
      if tempproject.public == true
        redirect_to project_show_public_path(params[:id])
      else
        redirect_to login_path
      end
    else
      pids = user.projectids.split(",");
      session[:lastproj] = params[:id]

      if pids.include? String(tempproject.id)
        @project = tempproject
        @complete = Project.complete_tasks_for_project(@project.id)
        @incomplete = Project.incomplete_tasks_for_project(@project.id)

        #gathering users
        @workers = Project.workers_for_project(@project.id)

        #gathering overall completion
        if (@incomplete.size + @complete.size) == 0
          @percentdone = 0
        else
          @percentdone = @complete.size*100 / (@complete.size + @incomplete.size)
        end
        #sorting tasks
        @tasks = Project.tasks_for_project(@project.id)

        #gathering messages
        @messages = Message.where(projectid: @project.id).order(created_at: :desc)




        respond_to do |format|
          format.html # show.html.erb
          format.mobile
          format.json { render json: @tasks }
        end
      else
        if tempproject.public == true
          redirect_to project_show_public_path(params[:id])
        else
          redirect_to projects_url
        end
      end
    end

  end

  def show_public
    @project = Project.find_by_id(params[:id])
    if !@project.public
      redirect_to root_path
    else
      @complete = Project.complete_tasks_for_project(@project.id)
      @incomplete = Project.incomplete_tasks_for_project(@project.id)
    end
  end

  def complete_tasks
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    tempproject = Project.find(params[:id])
    session[:lastproj] = params[:id]
    if pids.include? String(tempproject.id)
      @project = tempproject
      @complete = Project.complete_tasks_for_project(@project.id)
    end
  end

  def incomplete_tasks
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    tempproject = Project.find(params[:id])
    session[:lastproj] = params[:id]
    if pids.include? String(tempproject.id)
      @project = tempproject
      @incomplete = Project.incomplete_tasks_for_project(@project.id)
    end
  end

  def tasks
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    tempproject = Project.find(params[:id])
    session[:lastproj] = params[:id]
    if pids.include? String(tempproject.id)
      @project = tempproject
      @tasks = Project.tasks_for_project(@project.id)
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project.shares = ""
    @project.save!
    @is_muted = User.is_project_muted(session[:userid], @project.id)
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    user = User.find_by_id(session[:userid])
    @project.allshares = user.id
    respond_to do |format|
      if @project.save
        user.projectids += "," + String(@project.id)
        user.save!
        if project_params[:shares] == ""

        else
          share_params = {
            :proj => @project.id,
            :shares => project_params[:shares]
          }
          share (share_params)
        end
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.mobile { redirect_to @project }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.mobile { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def removeshare
    @project = Project.find_by_id(params[:id])
    @removeUser = User.find_by_id(params[:user])
    if @project && @removeUser
      shares = @project.allshares.split(",")
      newshares = ""
      shares.each do |shr|
        if shr != @removeUser.id.to_s
          newshares += shr + ","
        end
      end
      @project.update_column(:allshares, newshares)
      projects = @removeUser.projectids.split(',')
      newprojects = ''
      projects.each do |prj|
        if prj != @project.id.to_s
          newprojects += prj + ','
        end
      end
      @removeUser.update_column(:projectids, newprojects)

      for task in Task.where("assignedto = ?", (@removeUser.firstname + " " + @removeUser.lastname))
        if task.projectid == @project.projectid
          task.update_column(:assignedto, 'None')
        end
      end
    end
    redirect_to request.referrer, notice: "Team Members were successfully updated."
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    shares = @project.allshares.split(",")
    originalshares = @project.allshares
    found = false
    for share in shares
      olduser = User.find_by_id(share)
      if olduser
        if olduser.name
          if String(olduser.name).downcase == String(project_params[:shares]).downcase
            found = true
          end
        end
      end
    end

    puts 'xxxxxxxxxxxxxxx'
    puts params[:unsubscribe]
    #deal with muting project
    if params[:unsubscribe] == 'on'
      User.mute_project(session[:userid], @project.id)
      puts 'muting project'
    else
      User.unmute_project(session[:userid], @project.id)
    end

    respond_to do |format|
      if @project.update(project_params)
        if project_params[:shares] && project_params[:shares] != ""
          if found == false && project_params[:shares]
            pid = session[:lastproj]
            share_params = {
              :proj => pid,
              :shares => project_params[:shares],
              :project => @project.name,
              :morethan5 => false
            }
            @workers = Project.workers_for_project(@project.id)

            share(share_params)
            @project.save!
          else
            @project.allshares = originalshares
            @project.save!
          end
        end
        if URI(request.referrer).path == project_shares_path(@project.id)
          format.html { redirect_to project_shares_path(@project.id), notice: 'Project was successfully updated.' }
          format.mobile { redirect_to project_shares_path(@project.id) }
          format.json { head :no_content }
        else
          format.html { redirect_to @project, notice: 'Project was successfully updated.' }
          format.mobile { redirect_to @project }
          format.json { head :no_content }
        end
      else
        format.html { render action: 'edit' }
        format.mobile { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find_by_id(params[:id])
    @removeUser = User.find_by_id(session[:userid])
    if @project && @removeUser
      shares = @project.allshares.split(",")
      newshares = ""
      shares.each do |shr|
        if shr != @removeUser.id.to_s
          newshares += shr + ","
        end
      end
      @project.update_column(:allshares, newshares)
      projects = @removeUser.projectids.split(',')
      newprojects = ''
      projects.each do |prj|
        if prj != @project.id.to_s
          newprojects += prj + ','
        end
      end
      @removeUser.update_column(:projectids, newprojects)

      for task in Task.where("assignedto = ?", (@removeUser.firstname + " " + @removeUser.lastname))
        if task.projectid == @project.projectid
          task.update_column(:assignedto, 'None')
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.mobile { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  def share (shared_params)
    user = User.find_by_name(shared_params[:shares])
    if shared_params[:shares] != "" && user
      pids = user.projectids.split(",")
      found = false
      for pid in pids
        if pid == String(shared_params[:proj])
          found = true
        end
      end
      project = Project.find_by_id(shared_params[:proj])

      if found == false
        user.projectids = user.projectids + "," + String(shared_params[:proj])
        user.save!
      end

      message = "The project " + project.name + " has been shared with you on Agendue."
      subject = project.name + " has been shared with you"
      Notification.send_notifications_to_user(subject, message, project.id, user.id)


      project.allshares = project.allshares + "," + String(user.id)
        project.save!
    else
      Thread.new do
        new_share_params = {
          :newname => shared_params[:shares],
          :oldname => session[:name],
          :project => shared_params[:project]
        }
        UserMailer.new_share_email(new_share_params).deliver
        ActiveRecord::Base.connection.close
      end
      if shared_params[:shares]
        flash[:error] = "The user you tried to add isn't an Agendue member. They have been emailed to join."
      end
    end

  end

  def copy_start
    @projects = current_user_projects
    @user = User.find_by_id(session[:userid])
  end

  def copy_options
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    tempproject = Project.find(params[:id])
    session[:lastproj] = params[:id]
    if pids.include? String(tempproject.id)
      @oldproject = Project.find_by_id(params[:id])
      @oldproject.name += " copy"
    else
      redirect_to projects_path
    end
  end

  def copy_run
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    tempproject = Project.find(params[:id])
    session[:lastproj] = params[:id]
    if pids.include? String(tempproject.id)
        newname = params[:project][:name]
        oldproj = Project.find_by_id(params[:id])

        newproj = oldproj.dup
        newproj.name = newname
        newproj.save!
        people = newproj.allshares.split(',')
        returnval = ""
        oldmessages = Message.where(projectid: oldproj.id).order(created_at: :desc)
        if !params[:bulletins]
          for message in oldmessages
            newmsg = message.dup
            newmsg.projectid = newproj.id
            newmsg.save!
          end
        end
        people.each do |shr|
          user = User.find_by_id(shr.to_i)
          if user
            newprojects = user.projectids + String(newproj.id) + ','
            user.projectids = user.projectids + "," + String(newproj.id)
            returnval = '/'  + user.projectids
            user.save!
          end
        end

        tasks = Array.new()
        for task in Task.find(:all, :conditions => { :projectid => oldproj.id} )
          newtask = task.dup
          newtask.projectid = newproj.id
          if params[:incomplete]
            newtask.complete = false
          end
          if params[:assignments]
            newtask.assignedto = "None"
          end
          newtask.save!
        end
        if params[:notebook]
            newproj.wiki = nil
            newproj.save!
        end
        # render :text => User.find_by_id(people[1]).projectids
        redirect_to project_path(newproj), notice: "Project successfully copied."
    else
      redirect_to projects_path
    end
  end

  def allmessages
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    @project = Project.find(params[:id])
    if pids.include? String(@project.id)
      @messages = Message.where(projectid: params[:id]).order(created_at: :desc)
    else
      redirect_to projects_url
    end
  end

  def empty_wiki
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    @project = Project.find(params[:id])
    if pids.include? String(@project.id)

    else
      redirect_to projects_url
    end
    render :layout => false
  end

  def editprojectwiki
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    @project = Project.find(params[:id])
    if pids.include? String(@project.id)

    else
      redirect_to projects_url
    end
  end

  def updateprojectwiki
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    @project = Project.find_by_id(params[:id])

    if pids.include? String(@project.id)
      @project.wiki = params[:project][:wiki]
      @project.save!
      redirect_to project_path(@project), notice: "Notebook successfully updated."
    else
      redirect_to projects_url
    end
  end

  def showwiki
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    @project = Project.find_by_id(params[:id])

    if pids.include? String(@project.id)
    else
      redirect_to projects_url
    end
  end


  def analytics
    #DEPRECATED
    redirect_to project_analytics_path
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :projectid, :users, :shares, :allshares, :incomplete, :public)
    end

    def share_params
      params.permit(:proj, :shares)
    end

    def has_access_to_project
      pids = User.find_by_id(session[:userid]).projectids.split(",");
      @project = Project.find(params[:id])
      pids.include? String(@project.id)
    end

    def current_user_projects
      Project.projects_for_user(session[:userid])
    end


end
