# Load the Rails application.
require File.expand_path('../application', __FILE__)
RAILS_ENV = 'production'
RACK_ENV = 'production'
CalendarDateSelect.format = :iso_date
# Initialize the Rails application.
Agendue::Application.initialize!
