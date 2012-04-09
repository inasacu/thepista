# to run:    rake self_cron

desc "set reminder dates to schedules 3 days before"
task :self_cron => :environment do

  puts "Hour:  #{Time.zone.now.hour} "
  puts "TIME zone now:  #{Time.zone.now}"
  puts "Time now:  #{Time.now}"

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
  
  puts "Archive all messages older than 1 month, set all other emails to mark as read..."
    Comment.archive_comments
  puts "done."
  
end
