# to run:    sudo rake cron

desc "set reminder dates to schedules 3 days before"
task :cron => :environment do

  puts "Hour:  #{Time.zone.now.hour} - exact time cron job ran:  #{Time.zone.now}, time.now:  #{Time.now}"
  if Time.zone.now.hour == 23 # run at hour before midnight

    puts "archive all messages older than 1 month, set all other emails to mark as read..."
    # rake the_message_archive
    puts "done."

    puts "Sending schedule reminders..."
    Schedule.send_reminders
    puts "done."

    puts "Sending schedule RESULTS reminders ..."
    Schedule.send_results
    puts "done."

    puts "Sending after schedule COMMENT reminders..."
    Schedule.send_after_comments
    puts "done."

    puts "Sending after schedule scorecard..."
    Schedule.send_after_scorecards
    puts "done."

  end

end
