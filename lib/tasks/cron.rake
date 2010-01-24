task :cron => :environment do
 # if Time.zone.now.hour % 4 == 0 # run every four hours
 #   puts "Updating feed..."
 #   NewsFeed.update
 #   puts "done."
 # end

 # if Time.zone.now.hour == 0 # run at midnight
 #   User.send_reminders
 # end
 
 # heroku rake friendly_id:make_slugs MODEL=User --app thepista
 # heroku rake friendly_id:make_slugs MODEL=Group  --app thepista
 # heroku rake friendly_id:make_slugs MODEL=Schedule  --app thepista
 # heroku rake friendly_id:make_slugs MODEL=Fee --app thepista
 # heroku rake friendly_id:make_slugs MODEL=Payment  --app thepista
 
 rake theschedule_tags
 
end
