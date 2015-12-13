json.array!(@messages) do |msg|
	json.user User.find_by_id(msg.user).firstname + ' ' + User.find_by_id(msg.user).lastname
	json.subject msg.subject
	json.content msg.content
	json.created_at msg.created_at
end