class User < ActiveRecord::Base
	validates	:name, presence: true, uniqueness: true
	validates	:firstname, presence: true
	validates	:lastname, presence: true
	has_secure_password

	def self.is_project_muted(userid, projectid)
		muted_projects = User.get_muted_projects(userid)
		puts "got muted projects" + muted_projects.to_s
		found = false
		for prj in muted_projects
			if prj == projectid.to_s
					found = true
			end
		end
		return found
	end

	def self.mute_project(userid, projectid)
		found = User.is_project_muted(userid, projectid)
		if found != true
			muted_projects = User.get_muted_projects(userid)
			muted_projects << projectid
			User.save_muted_projects(userid, muted_projects)
		end
	end

	def self.get_muted_projects(userid)
		user = User.find_by_id(userid)
		muted_projects = Array.new
		if user && user.muted_projects
			all_muted_projects = user.muted_projects.split(',')
		end
		if all_muted_projects
			for prj in all_muted_projects
				if prj != ""
					muted_projects << prj
				end
			end
		end

		return muted_projects
	end

	def self.unmute_project(userid, projectid)
			muted_projects = User.get_muted_projects(userid)
			user = User.find_by_id(userid)
			muted_projects.delete(projectid)
			muted_projects = muted_projects.reject {|x| x == projectid.to_s}
			User.save_muted_projects(userid, muted_projects)
	end

	def self.save_muted_projects(userid, muted_projects_array)
		user = User.find_by_id(userid)
		string_val = ""
		for muted_project in muted_projects_array
			string_val = string_val + "," + muted_project.to_s
		end
		user.muted_projects = string_val
		user.save!
		puts "muted projects: " + user.muted_projects
	end

end
