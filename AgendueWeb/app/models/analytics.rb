class Analytics < ActiveRecord::Base

	def self.status_labels
		arr = Array.new(['Green', 'Yellow', 'Red'])
    	return arr
  	end
end
