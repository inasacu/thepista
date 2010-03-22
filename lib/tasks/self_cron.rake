# to run:    sudo rake self_cron

desc "set reminder dates to schedules 3 days before"
task :self_cron => :environment do
  
  puts "Hour:  #{Time.zone.now.hour}"
  # if Time.zone.now.hour == 22 # run at 22:00
    
    puts "archive all messages older than 1 month, set all other emails to mark as read..."
    # rake the_message_archive
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
  # end

end
