desc "This task is called by the Heroku scheduler add-on"
desc "cron job"

desc "adding a yo request for events within the next 48 hours..."
task :the_yo_request_schedule => :environment do |t|
  uri = URI.parse("#{YO_REQUEST_URL_ALL}")
  schedules = Schedule.find(:all, :conditions => ["schedules.starts_at >= ? and schedules.ends_at <= ? and 
                                                    schedules.played = false and schedules.archive = false", Time.zone.now, NEXT_48_HOURS])

    schedules.each do |schedule|
      response = Net::HTTP.post_form(uri, {'api_token' => ENV["YO_API"]})
      puts response.body
    end
end



# heroku run rake send_reminders --app zurb
task :send_reminders => :environment do
	puts "Sending schedule REMINDER notice... A:  #{Time.zone.now}"
	Schedule.send_reminders 
	puts "Sending schedule REMINDER notice... B:  #{Time.zone.now}"
end


# heroku run rake send_created --app zurb
task :send_created => :environment do
	puts "Sending schedule CREATED notice... A:  #{Time.zone.now}"
	# Schedule.send_created 
	puts "Sending schedule CREATED notice... B:  #{Time.zone.now}"
end


# heroku run rake send_results --app zurb
task :send_results => :environment do
	puts "Sending schedule RESULTS notice ... A:  #{Time.zone.now}"
	Schedule.send_results 
	puts "Sending schedule RESULTS notice ... B:  #{Time.zone.now}"
end 


# heroku run rake send_after_comments --app zurb
task :send_after_comments => :environment do
	puts "Sending after schedule COMMENT reminder notice... A:  #{Time.zone.now}"
	# Schedule.send_after_comments 
	puts "Sending after schedule COMMENT reminder notice... B:  #{Time.zone.now}"
end


# heroku run rake send_after_scorecards --app zurb
task :send_after_scorecards => :environment do
	puts "Sending after schedule SCORECARD reminder notice... A:  #{Time.zone.now}"
	# Schedule.send_after_scorecards 
	puts "Sending after schedule SCORECARD reminder notice... B:  #{Time.zone.now}"
end


# heroku run rake archive_messages --app zurb
task :archive_messages => :environment do
	puts "Archiving older than 1 month messages... A:  #{Time.zone.now}"
	Message.archive_messages
	puts "Archiving older than 1 month messages... B:  #{Time.zone.now}"
end

# heroku run rake generate_daily_slugs --app zurb
task :generate_daily_slugs => :environment do 
	
	puts "generate daily slugs... A:  #{Time.zone.now}"
	
	Schedule.find(:all, :conditions => ["played= false and created_at > ?", YESTERDAY]).each {|schedule| schedule.save }
	User.find(:all, :conditions => ["archive = false and created_at > ?", YESTERDAY]).each {|user| user.save }
	
	puts "generate daily slugs... B:  #{Time.zone.now}"
	
end
