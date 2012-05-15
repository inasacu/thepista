desc "This task is called by the Heroku scheduler add-on"
desc "cron job"

task :send_reminders => :environment do
  puts "Sending schedule reminders..."
  Schedule.send_reminders if DISPLAY_SEND_REMINDERS
  puts "done."
end


task :send_results => :environment do
    puts "Sending schedule RESULTS reminders ..."
    Schedule.send_results if DISPLAY_SEND_REMINDERS
    puts "done."
end 


task :send_after_comments => :environment do
    puts "Sending after schedule COMMENT reminders..."
    Schedule.send_after_comments if DISPLAY_SEND_REMINDERS
    puts "done."
end


task :send_after_scorecards => :environment do
    puts "Sending after schedule scorecard..."
    Schedule.send_after_scorecards if DISPLAY_SEND_REMINDERS
    puts "done."
end




