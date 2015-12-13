def process(event)
	data_json = JSON.parse(event)
	event_type = data_json['type']
	case event_type
		when "invoice.payment_succeeded"
			make_active(data_json) # Business logic, when payment succeeds
		when "invoice.payment_failed"
			make_inactive(data_json) # Business logic, when payment fails.
 	end
end