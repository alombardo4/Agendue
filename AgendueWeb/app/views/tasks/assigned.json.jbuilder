json.array!(@assigned) do |task|
	json.id task.id
	json.name task.name
	json.description task.description
	json.duedate task.duedate
	json.complete task.complete
	json.assignedto task.assignedto
	json.label task.label
	json.project Project.find_by_id(task.projectid).name
	json.projectid task.projectid
end