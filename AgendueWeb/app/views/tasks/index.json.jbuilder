json.array!(@tasks) do |task|
  json.extract! task, :name, :description, :duedate, :complete, :id, :projectid, :assignedto, :label
  json.url task_url(task, format: :json)
  json.project Project.find_by_id(task.projectid).name
end
