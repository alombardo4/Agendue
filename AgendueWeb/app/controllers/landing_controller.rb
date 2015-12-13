class LandingController < ApplicationController
	before_filter :authorize
    def index
    	@user = User.find_by_id(session[:userid])
    	if @user == nil
    		redirect_to login_path
    	end
    	#figure out the upcoming tasks and build productivity score
	    @incomplete = Task.assigned_incomplete_tasks(@user.id)

	   	@today = Array.new()
	   	@upcoming = Array.new()
	   	@overdue = Array.new()

	   	for task in @incomplete
	   		if task.duedate
		   		if task.duedate == Date.today #today
		   			@today << task
		   		elsif task.duedate < Date.today #overdue
		   			@overdue << task
		   		else #upcoming
		   			@upcoming << task
		   		end
		   	else
		   		@upcoming << task
		   	end
	   	end
	   	personal = Array.new()
   	    personal = PersonalTask.find(:all, :conditions => {:userid => session[:userid]})
   	    @personal = Array.new()
   	    for task in personal
   	    	if !task.complete
   	    		@personal << task
   	    	end
   	    end
        @personal.sort!  { |a,b| a.duedate.to_i <=> b.duedate.to_i }
    end

    def incomplete_count
    	@user = User.find_by_id(session[:userid])
	    @incomplete = Task.assigned_incomplete_tasks(@user.id)
    	@sum = @incomplete.count
    	personal = Array.new()
   	    personal = PersonalTask.find(:all, :conditions => {:userid => session[:userid]})
   	    @personal = Array.new()
   	    for task in personal
   	    	if !task.complete
   	    		@personal << task
   	    	end
   	    end
   	    @sum = @sum + @personal.count
    end

    def personal
	   	personal = Array.new()
   	    personal = PersonalTask.find(:all, :conditions => {:userid => session[:userid]})
   	    @personal = Array.new()
   	    for task in personal
   	    	if !task.complete
   	    		@personal << task
   	    	end
   	    end
        @personal.sort!  { |a,b| a.duedate.to_i <=> b.duedate.to_i }
    end

    def score
    	@user = User.find_by_id(session[:userid])

    	#figure out the upcoming tasks and build productivity score
	    @tasks = Array.new()
	    if User.find_by_id(session[:userid]).projectids != nil
	      pids = User.find_by_id(session[:userid]).projectids.split(",");
	      for pid in pids
	        project = Project.find_by_id(pid)
	        if project
	          for task in Task.find(:all, :conditions => { :projectid => project.id} )
	            @tasks << task
	          end
	        end
	      end
	    end
	    @tasks.sort!  { |a,b| DateTime.parse(a.duedate.to_s + 'T00:00:00+0:00').to_i <=> DateTime.parse(b.duedate.to_s + 'T00:00:00+0:00').to_i }
	    nCount = 0
	    lengthRootCount = 0
	    for task in @tasks
	      if task.assignedto == @user.firstname + " " + @user.lastname
	        timeToComplete = 0
        	if task.datecomplete
        		timeToComplete = (task.datecomplete.to_i - task.created_at.to_i) / 60
        	else
        		timeToComplete = (DateTime.now.to_i - task.created_at.to_i) / 60
        	end
        	lengthOfTask = (DateTime.parse(task.duedate.to_s + 'T00:00:00+0:00').to_i - task.created_at.to_i) / 60
        	if lengthOfTask > 1440
        		lenSqr = Math.sqrt(lengthOfTask)
        		lengthRootCount += lenSqr
        		n = lenSqr - 0.5 * timeToComplete / lenSqr
        		if n < 0
        			n = 0
        		end
        		nCount += n
        	end
	      end
	    end
	    if lengthRootCount == 0
	    	@personalScore = 0
	    else
	    	@personalScore = (1000 * Math.sqrt(nCount / lengthRootCount)).round(0)
	    end
    end
end
