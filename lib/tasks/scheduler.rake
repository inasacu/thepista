desc "This task is called by the Heroku scheduler add-on"
desc "cron job"

task :send_reminders => :environment do
  puts "Sending schedule reminders..."
  Schedule.send_reminders 
  puts "done."
end


task :send_results => :environment do
    puts "Sending schedule RESULTS reminders ..."
    Schedule.send_results 
    puts "done."
end 


task :send_after_comments => :environment do
    puts "Sending after schedule COMMENT reminders..."
    Schedule.send_after_comments 
    puts "done."
end


task :send_after_scorecards => :environment do
    puts "Sending after schedule scorecard..."
    Schedule.send_after_scorecards 
    puts "done."
end


task :archive_messages => :environment do
    puts "Archiving older than 1 month messages..."
    Message.archive_messages 
    puts "done."
end


