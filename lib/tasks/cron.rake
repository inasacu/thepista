task :cron => :environment do
 # if Time.zone.now.hour % 4 == 0 # run every four hours
 #   puts "Updating feed..."
 #   NewsFeed.update
 #   puts "done."
 # end

 # if Time.zone.now.hour == 0 # run at midnight
 #   User.send_reminders
 # end
 
 # rake friendly_id:make_slugs MODEL=User 
 # rake friendly_id:make_slugs MODEL=Group 
 # rake friendly_id:make_slugs MODEL=Schedule 
 # rake friendly_id:make_slugs MODEL=Fee
 # rake friendly_id:make_slugs MODEL=Payment 
 
end
