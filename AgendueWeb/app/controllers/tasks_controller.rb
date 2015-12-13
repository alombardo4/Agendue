class TasksController < ApplicationController
  before_filter :authorize
  skip_before_filter :authorize, only: [:calendar_ics]
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:destroy]

  # GET /tasks
  # GET /tasks.json

  def mark_complete(task)
    users = Project.find_by_id(@task.projectid).allshares.split(",")
    task.datecomplete = DateTime.now
    task.save!
    users.each do |user|
      us = User.find_by_id(user)
      if us && us.id != session[:userid]
        message = "The task " + task.name + " has been marked complete."
        subject = task.name + " is complete"
        Notification.send_notifications_to_user(subject, message, @task.projectid, us.id)

      end
    end
  end

  def mark_incomplete(task)
    task.complete = false
    task.datecomplete = nil
    task.save!
  end

  def send_assignment(task, assignemail)
    user = User.find_by_name(assignemail)
    project = Project.find_by_id(task.projectid)
    message = "The task " + task.name + " in project " + project.name + " has been assigned to you."
    subject = task.name + " assigned to you"
    Notifications.send_notifications_to_user(subject, message, project.id, user.id)
  end


  def labels
    @labels = Task.labels
  end

  def index
    @user = User.find_by_id(session[:userid])
    @complete = Task.all_complete_tasks(@user.id)
    @incomplete = Task.all_incomplete_tasks(@user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def allcomplete
    @user = User.find_by_id(session[:userid])
    @complete = Task.all_complete_tasks(@user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end


  def allincomplete
    @user = User.find_by_id(session[:userid])
    @incomplete = Task.all_incomplete_tasks(@user.id)
    respond_to do |format|
      format.html # index.html.erb
      format.json
    end
  end

  def assigned
    @user = User.find_by_id(session[:userid])

    @incomplete = Task.assigned_incomplete_tasks(@user.id)
    @complete = Task.assigned_complete_tasks(@user.id)

  end

  def assignedcomplete
    @user = User.find_by_id(session[:userid])
    @complete = Task.assigned_complete_tasks(@user.id)
  end

  def assignedincomplete
    @user = User.find_by_id(session[:userid])
    @incomplete = Task.assigned_incomplete_tasks(@user.id)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    pids = User.find_by_id(session[:userid]).projectids.split(",");
    tempTask = Task.find(params[:id])
    if pids.include? String(tempTask.projectid)
      @task = tempTask
      @project = Project.find_by_id(@task.projectid)

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @task }
      end
    else
      redirect_to projects_path
    end
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @user = User.find_by_id(session[:userid])
    project = Project.find_by_id(session[:lastproj])
    if !project
      redirect_to projects_path
    end
    shares = project.allshares.split(",")
    @allshares = Array.new()
    shares.each do |shr|
      if shr
        user = User.find_by_id(shr)
        if user
          @allshares << user.firstname + " " + user.lastname
        end
      end
    end
    @allshares << "None"
    @sel = "None"
    @run = true
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @user = User.find_by_id(session[:userid])
    pids = @user.projectids.split(",");
    if !(pids.include? String(@task.projectid))
      redirect_to projects_path
    else
      project = Project.find_by_id(@task.projectid)
      shares = project.allshares.split(",")
      @allshares = Array.new()
      shares.each do |shr|
        if shr
          user = User.find_by_id(shr)
          if user
            @allshares << user.firstname + " " + user.lastname
          end
        end
      end
      @allshares << "None"
      if @allshares.include? @task.assignedto
        @sel = @task.assignedto
      else
        @sel = "None"
      end
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @user = User.find_by_id(session[:userid])
    if task_params[:name] == nil || task_params[:name] == ""
      flash[:error] = "You must enter a name for a task"
      redirect_to new_task_path
    else
      # Used for premium check
      # if @user.premium
      #   run = true
      # else
      #   counter = 0
      #   pids = @user.projectids.split(",");
      #   for task in Task.all
      #     if pids.include? String(task.projectid)
      #       counter = counter + 1
      #     end
      #   end
      #   if counter < 25
      #     run = true
      #   else
      #     run = false
      #   end
      # end
      @task = Task.new(task_params)
      @task.projectid = session[:lastproj]
      @task.save
      if task_params[:assignedto] == nil || task_params[:assignedto] == ""
        @task.assignedto = "None"
      end
      if task_params[:label] == nil || task_params[:label] == ""
        @task.label = 0
      end
      if @task.assignedto != "None"
        assignemail = ""
        users = Project.find_by_id(@task.projectid).allshares.split(",")

        users.each do |user|
          us = User.find_by_id(user)
          if us
            if (us.firstname + " " + us.lastname) == @task.assignedto
              if us.noemail != true
                assignemail = us.name
              end
            end
          end
        end
        user = User.find_by_id(assignemail)
        if user && user.id != session[:userid]
          message = "The task " + task.name + " in project " + project.name + " has been assigned to you."
          subject = task.name + " assigned to you"
          Notification.send_notifications_to_user(subject, message, @task.projectid, user.id)
        end
      end
      respond_to do |format|
        if @task.save
          format.html { redirect_to project_path(@task.projectid), notice: 'Task was successfully created.' }
          format.mobile { redirect_to project_path(@task.projectid) }
          format.json { render action: 'show', status: :created, location: @task }
        else
          format.html { render action: 'new' }
          format.mobile { render action: 'new' }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])
    oldtaskname = @task.name
    if @task
      if request.referrer && URI(request.referrer).path == edit_task_path(@task) && (task_params[:name] == nil|| task_params[:name] == "")
        flash[:error] = "You must enter a name for a task"
        redirect_to edit_task_path(@task.id)
      else
        oldcomplete = @task.complete
        oldassignee = @task.assignedto
        users = Project.find_by_id(@task.projectid).allshares.split(",")
        found = false
        if @task.assignedto == nil
          @task.assignedto = "None"
        end
        if task_params[:assignedto] == nil || task_params[:assignedto] == ""
          task_params[:assignedto] = @task.assignedto
        end
        if !(users.include? task_params[:assignedto])
          task_params[:assignedto] = @task.assignedto
        end
        # if task_params[:label] == nil || task_params[:label] == ""
        #   @task.label = 0
        # end
        @task.update(task_params)
        @task.save!
        if @task.assignedto != oldassignee
          if @task.assignedto != "None"
            assignemail = ""
            users.each do |user|
              us = User.find_by_id(user)
              if us
                if (us.firstname + " " + us.lastname) == @task.assignedto
                  if us.noemail != true
                    assignemail = us.name
                  end
                end
              end
            end
            send_assignment(@task, assignemail)

          end
        end

        if @task.complete == true && @task.complete != oldcomplete
          mark_complete(@task)
        elsif @task.complete == false
          mark_incomplete(@task)
        end

        respond_to do |format|
          if @task
                if oldcomplete == false && @task.complete == true
                  @task.datecomplete = @task.updated_at
                elsif oldcomplete == true && @task.complete == false
                  @task.datecomplete = nil
                end
                @task.save!
            flash[:alert] = 'Task was successfully updated.'
            if request.referrer && URI(request.referrer).path != edit_task_path(@task)
              format.html { redirect_to request.referrer }
              format.mobile { redirect_to request.referrer, notice: 'Task was successfully updated.' }
              format.json { head :no_content }
            elsif request.referrer && URI(request.referrer).path == edit_task_path(@task)
              format.html { redirect_to project_path(@task.projectid), notice: 'Task was successfully updated.' }
              format.mobile { redirect_to project_path(@task.projectid), notice: 'Task was successfully updated.' }
              format.json { head :no_content }
            else
              format.html { redirect_to task_path(@task.id), notice: 'Task was successfully updated.' }
              format.mobile { redirect_to task_path(@task.id), notice: 'Task was successfully updated.' }
              format.json { head :no_content }
            end
          else
            format.html { render action: 'edit' }
            format.mobile { render action: 'edit' }
            format.json { render json: @task.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      flash[:error] = "You must enter a name for a task"
      redirect_to edit_task_path(@task.id)
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    projectid = @task.projectid
    if @task.present?
      @task.destroy
    end
    # @task.destroy
    respond_to do |format|
      if URI(request.referrer).path == project_path(Project.find_by_id(@task.projectid))
        format.html { redirect_to request.referrer, notice: 'Task was successfully deleted.' }
        format.mobile { redirect_to request.referrer, notice: 'Task was successfully deleted.' }
        format.json { head :no_content }
      elsif URI(request.referrer).path == tasks_path
        format.html { redirect_to project_path(projectid), notice: 'Task was successfully deleted.' }
        format.mobile { redirect_to project_path(projectid), notice: 'Task was successfully deleted.' }
        format.json { head :no_content }
      else
        format.html { redirect_to project_path(projectid), notice: 'Task was successfully deleted.' }
        format.mobile { redirect_to project_path(projectid), notice: 'Task was successfully deleted.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find_by_taskid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :description, :duedate, :personalduedate, :complete, :taskid, :projectid, :assignedto, :label)
    end
end
