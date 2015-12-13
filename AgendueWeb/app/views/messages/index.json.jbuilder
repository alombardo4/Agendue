json.array!(@messages) do |message|
  json.extract! message, :user, :subject, :content
  json.url message_url(message, format: :json)
end
