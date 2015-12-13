class AnalyticsController < ApplicationController
  before_action :set_project
  before_filter :authorize, :premium, :on_project

  def index
  end

  def status
    @tasks = Task.where(projectid: @project.id).load
    @incomplete = Array.new()
    @complete = Array.new()
    for task in @tasks
    	if task.complete == true
    		@complete << task
    	else
    		@incomplete << task
    	end
    end
    @overdue = Array.new
    for task in @incomplete
      if task.duedate != nil && task.duedate < DateTime.now().to_date
        @overdue << task
      end
    end

    @status = 0 # 0 = green, 1 = yellow, 2 = red
    if @overdue.count > 5 || @overdue.count > 0.4 * @incomplete.count
      @status = 2
    elsif (@overdue.count > 2 && @overdue.count <= 5) || @overdue.count > 0.2 * @incomplete.count
      @status = 1
    end
  end

  def tasks_per_user
    @tasks = Task.where(projectid: @project.id).load

    @workers = Project.workers_for_project(@project.id)
    @numberAssignedByUser = Hash.new
    for worker in @workers
      totalTasks = 0
      for task in @tasks
        if task.assignedto == (worker.firstname + ' '  + worker.lastname)
          totalTasks = totalTasks + 1
        end
        @numberAssignedByUser[worker] = totalTasks
      end
    end
  end

  def tasks_complete_per_user
    @tasks = Task.where(projectid: @project.id).load

    @workers = Project.workers_for_project(@project.id)

    @percentCompleteByUser = Hash.new
    for worker in @workers
      totalTasks = 0
      completeTasks = 0
      for task in @tasks
        if task.assignedto == (worker.firstname + ' '  + worker.lastname)
          if task.complete == true
            completeTasks = completeTasks + 1
          end
          totalTasks = totalTasks + 1
        end
        if totalTasks != 0
          @percentCompleteByUser[worker] = completeTasks * 100 / totalTasks
        else
          @percentCompleteByUser[worker] = 0
        end
      end
    end
  end

  def percent_complete
    @tasks = Task.where(projectid: @project.id).load
    @incomplete = Array.new()
    @complete = Array.new()
    for task in @tasks
      if task.complete == true
        @complete << task
      else
        @incomplete << task
      end
    end
    @overdue = Array.new
    for task in @incomplete
      if task.duedate != nil && task.duedate < DateTime.now().to_date
        @overdue << task
      end
    end

    @incomplete_count = @incomplete.count - @overdue.count
    @overdue_count = @overdue.count
    @complete_count = @complete.count

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end
end