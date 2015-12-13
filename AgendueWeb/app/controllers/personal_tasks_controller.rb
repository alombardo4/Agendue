class PersonalTasksController < ApplicationController
  before_action :authorize, only: [:show, :edit, :update, :destroy]
  # GET /personal_tasks
  # GET /personal_tasks.json
  def index
    @personal_tasks = PersonalTask.all_personal_tasks(session[:userid])
    @complete = PersonalTask.all_complete_personal_tasks(session[:userid])
    @incomplete = PersonalTask.all_incomplete_personal_tasks(session[:userid])
  end

  def incomplete
    @incomplete = PersonalTask.all_incomplete_personal_tasks(session[:userid])
  end

  def complete
    @complete = PersonalTask.all_complete_personal_tasks(session[:userid])
  end

  # GET /personal_tasks/1
  # GET /personal_tasks/1.json
  def show
    @personal_task = PersonalTask.find(params[:id])
    if @personal_task.userid != session[:userid]
      flash[:error] = "You don't have access to that task"
      redirect_to personal_tasks_path
    end
  end

  # GET /personal_tasks/new
  def new
    @personal_task = PersonalTask.new
  end

  # GET /personal_tasks/1/edit
  def edit
    @personal_task = PersonalTask.find(params[:id])
    if @personal_task.userid != session[:userid]
      flash[:error] = "You don't have access to that task"
      redirect_to personal_tasks_path
    end
  end

  # POST /personal_tasks
  # POST /personal_tasks.json
  def create
    @personal_task = PersonalTask.new(personal_task_params)
    @personal_task.userid = session[:userid]
    if personal_task_params[:label] == nil || personal_task_params[:label] == ""
      @personal_task.label = 0
    end
    @personal_task.complete = false
    respond_to do |format|
      if @personal_task.save
        flash[:alert] = "Task created"
        format.html { redirect_to @personal_task }
        format.json { render action: 'show', status: :created, location: @personal_task }
      else
        format.html { render action: 'new' }
        format.json { render json: @personal_task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personal_tasks/1
  # PATCH/PUT /personal_tasks/1.json
  def update
    @personal_task = PersonalTask.find(params[:id])
    if @personal_task.userid != session[:userid]
      flash[:error] = "You don't have access to that task"
      redirect_to personal_tasks_path
    else
      respond_to do |format|
        if @personal_task.update(personal_task_params)
          flash[:alert] = "Task saved"
          format.html { redirect_to personal_tasks_path}
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @personal_task.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /personal_tasks/1
  # DELETE /personal_tasks/1.json
  def destroy
    set_personal_task
    if @personal_task.userid != session[:userid]
      flash[:error] = "You don't have access to that task"
      redirect_to personal_tasks_path
    else
      @personal_task.destroy
      respond_to do |format|
        flash[:alert] = "Task deleted"
        format.html { redirect_to personal_tasks_url }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal_task
      @personal_task = PersonalTask.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personal_task_params
      params.require(:personal_task).permit(:title, :label, :description, :complete, :userid, :duedate)
    end
end
