namespace :Agendue do
  task :duedate_notifications => :environment do
    puts "Sending notifications..."
    Task.send_daily_notifications
  end
end
