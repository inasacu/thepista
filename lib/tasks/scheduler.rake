desc "This task is called by the Heroku scheduler add-on"
desc "cron job"

desc "adding a yo request for events within the next 48 hours..."
task :the_yo_request => :environment do |t|
  matches = Match.find(:all, :select => "users.id, users.name, users.email, users.yo_username, matches.schedule_id, matches.type_id", 
                             :joins => "JOIN schedules on schedules.id = matches.schedule_id JOIN users on users.id = matches.user_id",
                             :conditions => ["users.yo_username is not null and users.archive is not null and
                                              schedules.starts_at >= ? and schedules.ends_at <= ? and 
                                              schedules.played = false and schedules.archive = false and 
                                              schedules.send_reminder_at is null and matches.archive = false", Time.zone.now, NEXT_48_HOURS])
  counter = 0                                   
  the_schedules = []                                    
  matches.each do |match|
    params = {'api_token' => ENV["YO_API"], 'username' => '#{match.yo_username}', 'trigger' => 'Hay Partido!', 'button' => 'Submit'}
    the_request = Net::HTTP.post_form(URI.parse("#{YO_REQUEST_URL}"), params)
    puts the_request.body
    puts "#{counter+=1}: #{match.yo_username}"
    the_schedules << match.schedule_id unless the_schedules.include?(match.schedule_id)
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
