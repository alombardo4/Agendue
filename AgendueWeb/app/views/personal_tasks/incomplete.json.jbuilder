json.array!(@incomplete) do |personal_task|
  json.extract! personal_task, :id, :title, :description, :complete, :label, :userid, :duedate
  if personal_task.duedate
  	json.duedate personal_task.duedate.to_date
  else
  	json.duedate personal_task.duedate
  end
  json.name personal_task.title
  json.url personal_task_url(personal_task, format: :json)
  json.personal true
end
