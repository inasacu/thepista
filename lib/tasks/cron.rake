# to run:    sudo rake cron

desc "cron job"
task :cron => :environment do

  puts "Hour:  #{Time.zone.now.hour} "
  puts "TIME zone now:  #{Time.zone.now}"
  puts "Time now:  #{Time.now}"
  
  # if Time.zone.now.hour == 23 or Time.zone.now.hour == 0 # run at hour before midnight

    puts "Sending schedule reminders..."
    Schedule.send_reminders if DISPLAY_SEND_REMINDERS
    puts "done."

    puts "Sending schedule RESULTS reminders ..."
    Schedule.send_results if DISPLAY_SEND_REMINDERS
    puts "done."

    puts "Sending after schedule COMMENT reminders..."
    Schedule.send_after_comments if DISPLAY_SEND_REMINDERS
    puts "done."

    puts "Sending after schedule scorecard..."
    Schedule.send_after_scorecards if DISPLAY_SEND_REMINDERS
    puts "done."
    
    puts "Archive all messages older than 1 month, set all other emails to mark as read..."
      Message.archive_messages
    puts "done."
  
  # end

end
