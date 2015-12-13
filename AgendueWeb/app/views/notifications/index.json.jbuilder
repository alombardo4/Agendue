json.array!(@notifications) do |notification|
  json.extract! notification, :id, :message, :device_token, :notification_os, :project_id
  json.url notification_url(notification, format: :json)
end
