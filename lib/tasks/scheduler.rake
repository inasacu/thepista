desc "This task is called by the Heroku scheduler add-on"
desc "cron job"

# heroku run rake send_reminders --app thepista
task :send_reminders => :environment do
  puts "Sending schedule REMINDER notice... A:  #{Time.zone.now}"
  Schedule.send_reminders 
  puts "Sending schedule REMINDER notice... B:  #{Time.zone.now}"
end


# heroku run rake send_created --app thepista
task :send_created => :environment do
  puts "Sending schedule CREATED notice... A:  #{Time.zone.now}"
  Schedule.send_created 
  puts "Sending schedule CREATED notice... B:  #{Time.zone.now}"
end


# heroku run rake send_results --app thepista
task :send_results => :environment do
    puts "Sending schedule RESULTS notice ... A:  #{Time.zone.now}"
    Schedule.send_results 
    puts "Sending schedule RESULTS notice ... B:  #{Time.zone.now}"
end 


# heroku run rake send_after_comments --app thepista
task :send_after_comments => :environment do
    puts "Sending after schedule COMMENT reminder notice... A:  #{Time.zone.now}"
    Schedule.send_after_comments 
    puts "Sending after schedule COMMENT reminder notice... B:  #{Time.zone.now}"
end


# heroku run rake send_after_scorecards --app thepista
task :send_after_scorecards => :environment do
    puts "Sending after schedule SCORECARD reminder notice... A:  #{Time.zone.now}"
    Schedule.send_after_scorecards 
    puts "Sending after schedule SCORECARD reminder notice... B:  #{Time.zone.now}"
end


# heroku run rake archive_messages --app thepista
task :archive_messages => :environment do
    puts "Archiving older than 1 month messages... A:  #{Time.zone.now}"
    Message.archive_messages
    puts "Archiving older than 1 month messages... B:  #{Time.zone.now}"
end

# heroku run rake generate_daily_slugs --app thepista
task :generate_daily_slugs => :environment do 
	puts "generate daily slugs... A:  #{Time.zone.now}"
	Schedule.find_each(&:save)
	User.find_each(&:save)
	Marker.find_each(&:save)
	Venue.find_each(&:save)
	Installation.find_each(&:save)
	puts "generate daily slugs... B:  #{Time.zone.now}"
end
