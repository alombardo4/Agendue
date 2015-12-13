json.array!(@workers) do |worker|
	json.name worker.firstname + ' ' + worker.lastname
	if worker.facebook
		json.facebook "https://graph.facebook.com/" + worker.facebook.to_s + "/picture"
	else
		json.facebook nil
	end
	if worker.google_picture
		json.google_picture worker.google_picture
	else
		json.google_picture nil
	end
	json.premium (worker.premium || worker.premiumoverride)
	json.userid	worker.id
end
