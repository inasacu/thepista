# to run:    sudo rake cron

desc "set reminder dates to schedules 3 days before"
task :cron => :environment do
  
  if Time.zone.now.hour == 0 # run at midnight
    
    puts "archive all messages older than 1 month, set all other emails to mark as read..."
    rake the_message_archive
    puts "done."

    puts "Sending schedule reminders..."
    Schedule.send_reminders
    puts "done."

    puts "Sending schedule RESULTS reminders ..."
    Schedule.send_results
    puts "done."
    
    puts "Sending schedule COMMENT reminders..."
    Schedule.send_after_comment_scorecards
    puts "done."
  end

end
