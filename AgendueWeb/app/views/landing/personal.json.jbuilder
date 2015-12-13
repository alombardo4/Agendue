if @personal.length == 0
	json.shares ''
else
	json.array!(@personal) do |task|
	    json.id task.id
	    json.name task.name
	    json.description task.description
		if task.duedate
		  	json.duedate task.duedate.to_date
		else
		  	json.duedate task.duedate
		end
	    json.complete false
	    json.shares ''
	    json.label task.label
			json.personal true
	end
end
