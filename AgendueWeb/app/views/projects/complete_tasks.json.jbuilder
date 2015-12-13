json.array!(@complete) do |task|
    json.id task.id
    json.name task.name
    json.projectid task.projectid
    json.description task.description
    json.duedate task.duedate
    json.complete task.complete
    json.assignedto task.assignedto
    json.label task.label
    if task.datecomplete
    	json.datecomplete task.datecomplete.to_date
    else
    	json.datecomplete task.datecomplete
    end
end