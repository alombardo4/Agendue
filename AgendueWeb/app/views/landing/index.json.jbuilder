if @incomplete.length == 0
	json.shares ''
else
	json.array!(@incomplete) do |task|
	    json.id task.id
	    json.name task.name
	    json.description task.description
	    json.duedate task.duedate
	    json.complete false
	    json.assignedto task.assignedto
	    json.shares ''
	    json.label task.label
	    json.projectid task.projectid
	end
end