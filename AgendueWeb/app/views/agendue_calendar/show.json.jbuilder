json.array!(@all_items) do |task|
	json.id task.id
	json.title task.name
	json.description task.description
	if task.duedate
		json.start DateTime.parse(task.duedate.to_s + "T00:00:00+0:00Z")
		json.end DateTime.parse(task.duedate.to_s + "T00:00:00+0:00Z")
	else
		if task.complete == true && task.projectid
			json.start task.datecomplete
			json.end task.datecomplete
		else
			json.start DateTime.parse(Date.today.to_s + "T00:00:00+0:00Z")
			json.end DateTime.parse(Date.today.to_s + "T00:00:00+0:00Z")
		end
	end

	json.textColor "black"
	if task.assignedto == @user.firstname + " " + @user.lastname
		json.borderColor "#f7931e"
		if task.complete == true
			json.backgroundColor "#ffab26"
		else
			json.backgroundColor "white"
		end
	else
		json.borderColor "#3692d6"
		if task.complete == true
			json.backgroundColor "#b4d8eb"
		else
			json.backgroundColor "white"
		end
	end
		if task.projectid
	  	json.url task_url(task, format: :html)
		else
			json.url personal_task_url(task)
		end
  	json.duedate task.duedate
  	json.complete task.complete
  	json.assignedto task.assignedto
  	json.label task.label
		if task.projectid
			json.project Project.find_by_id(task.projectid).name
			json.projectid task.projectid
		else
			json.project nil
			json.projectid nil
		end



  	json.label task.label
		if task.projectid
			json.personal false
		else
			json.personal true
		end
end
