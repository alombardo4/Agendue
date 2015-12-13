class PersonalTask < ActiveRecord::Base
	def name
		title
	end

	def assignedto
		user = User.find_by_id(userid)
		return user.firstname + " " + user.lastname
	end

	def projectid
		nil
	end

	def self.all_personal_tasks(id)
		@personal_tasks = PersonalTask.find(:all, :conditions => {:userid => id})
    if @personal_tasks == nil
      @personal_tasks = Array.new()
    end

		@personal_tasks = PersonalTask.sort(@personal_tasks)

	end

	def self.all_incomplete_personal_tasks(id)
		@incomplete = PersonalTask.find(:all, :conditions => {:userid => id, :complete => false })
    if @incomplete == nil
      @incomplete = Array.new()
    end

		@incomplete = PersonalTask.sort(@incomplete)

	end

	def self.all_complete_personal_tasks(id)
		@complete = PersonalTask.find(:all, :conditions => {:userid => id, :complete => true })
		if @complete == nil
			@complete = Array.new()
		end

		@complete = PersonalTask.sort(@complete)
	end

	def self.sort(tasks)
		tasks.sort do |a,b|
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

	def self.labels
		arr = Array.new(['None', 'Red', 'Green', 'Blue', 'Yellow'])
    	return arr
  	end
end
