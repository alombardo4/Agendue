class Project < ActiveRecord::Base
  validates	:name, presence: true
  def self.workers_for_project(id)
    @workers = Array.new()
    project = Project.find_by_id(id)
    for shared in project.allshares.split(',')
      tempuser = User.find_by_id(shared)
      if tempuser
        @workers << tempuser
      end
    end
    @workers.sort! { |a, b| (a.firstname + " " + a.lastname).downcase <=> (b.firstname + " " + b.lastname).downcase }
  end

  def self.tasks_for_project(id)
    @tasks = Array.new
    for task in Task.where(projectid: id).load
    	@tasks << task
    end
    @tasks.sort do |a,b|
    	case
    	when a.duedate == nil
    		1
    	when b.duedate == nil
    		-1
    	else
    		DateTime.parse(a.duedate.to_s + 'T00:00:00+0:00').to_i <=> DateTime.parse(b.duedate.to_s + 'T00:00:00+0:00').to_i
    	end
    end
  end

  def self.incomplete_tasks_for_project(id)
  	tasks = Project.tasks_for_project(id)
  	@incomplete = Array.new
  	for task in tasks
  		if task.complete == nil || task.complete == false
  			@incomplete << task
  		end
  	end
  	@incomplete
  end

  def self.complete_tasks_for_project(id)
  	tasks = Project.tasks_for_project(id)
  	@complete = Array.new
  	for task in tasks
  		if task.complete == true
  			@complete << task
  		end
  	end
  	@complete
  end

  def self.projects_for_user(id)
    @projects = Array.new()
    if User.find_by_id(id).projectids != nil
      pids = User.find_by_id(id).projectids.split(",")
      for pid in pids
        project = Project.find_by_id(pid)
        if project
          @projects << project
        end
      end
    end
    @projects.sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end
end
