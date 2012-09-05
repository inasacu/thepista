desc "This task is called by the Heroku scheduler add-on"
desc "cron job"

# heroku run rake send_reminders --app thepista
task :send_reminders => :environment do
  puts "Sending schedule REMINDER notice..."
  Schedule.send_reminders 
  puts "done."
end


# heroku run rake send_created --app thepista
task :send_created => :environment do
  puts "Sending schedule CREATED notice..."
  Schedule.send_created 
  puts "done."
end


# heroku run rake send_results --app thepista
task :send_results => :environment do
    puts "Sending schedule RESULTS notice ..."
    Schedule.send_results 
    puts "done."
end 


# heroku run rake send_after_comments --app thepista
task :send_after_comments => :environment do
    puts "Sending after schedule COMMENT reminder notice..."
    Schedule.send_after_comments 
    puts "done."
end


# heroku run rake send_after_scorecards --app thepista
task :send_after_scorecards => :environment do
    puts "Sending after schedule SCORECARD reminder notice..."
    Schedule.send_after_scorecards 
    puts "done."
end


# heroku run rake archive_messages --app thepista
task :archive_messages => :environment do
    puts "Archiving older than 1 month messages..."
    Message.archive_messages 
    puts "done."
end


