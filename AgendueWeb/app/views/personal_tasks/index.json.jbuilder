json.array!(@personal_tasks) do |personal_task|
  json.extract! personal_task, :id, :title, :description, :complete, :label, :userid, :duedate
  json.url personal_task_url(personal_task, format: :json)
  json.personal true
end
