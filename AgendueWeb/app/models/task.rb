class Task < ActiveRecord::Base
	def self.labels
		arr = Array.new(['None', 'Red', 'Green', 'Blue', 'Yellow'])
    	return arr
  	end

  	def self.calendar_random_path(id)
  		user = User.find_by_id(id)
  		string_val = user.firstname + user.id.to_s + user.lastname
  		string_val = Digest::MD5.hexdigest(string_val)
  	end

  	def self.all_incomplete_tasks(id)
  		projects = Project.projects_for_user(id)
  		@tasks = Array.new
  		for project in projects
  			@tasks += Project.incomplete_tasks_for_project(project.id)
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

  	def self.all_complete_tasks(id)
  		projects = Project.projects_for_user(id)
  		@tasks = Array.new
  		for project in projects
  			@tasks += Project.complete_tasks_for_project(project.id)
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

  	def self.assigned_incomplete_tasks(id)
  		alltasks = Task.all_incomplete_tasks(id)
  		@tasks = Array.new
  		@user = User.find_by_id(id)
  		for task in alltasks
  			if task.assignedto == @user.firstname + " " + @user.lastname
  				@tasks << task
  			end
  		end
  		@tasks
  	end

  	def self.assigned_complete_tasks(id)
  		alltasks = Task.all_complete_tasks(id)
  		@tasks = Array.new
  		@user = User.find_by_id(id)
  		for task in alltasks
  			if task.assignedto == @user.firstname + " " + @user.lastname
  				@tasks << task
  			end
  		end
  		@tasks
  	end

  	def self.all_tasks(id)
  		projects = Project.projects_for_user(id)
  		@tasks = Array.new
  		for project in projects
  			@tasks += Project.tasks_for_project(project.id)
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

	def self.send_daily_notifications
	    tasks = Task.all
	#    File.open("/Users/alec/Desktop/cron.txt", 'w') { |file| file.write("your text") }
        # tasks = Task.find(:all, :conditions => { :complete => false, :duedate => Date.today.to_date } )
        for task in tasks
        	if task.complete != true
	        	if task.duedate == Date.today
		        	project = Project.find_by_id(task.projectid)
		        	uids = project.allshares.split(',')
		        	if uids && uids.count > 0
			        	for uid in uids
			        		user = User.find_by_id(uid)
			        		if user
			        			user_name = user.firstname + " " + user.lastname
			        			if user_name == task.assignedto
									    message = "The task " + task.name + " in project " + project.name + " is due today!"
									    subject = task.name + " due today"
									    Notification.send_notifications_to_user(subject, message, project.id, user.id)
			        			end
			        		end
			        	end
			        end
			    end
			end
        end
  	end
end
