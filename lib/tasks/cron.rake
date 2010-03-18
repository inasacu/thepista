task :cron => :environment do
  
  if Time.zone.now.hour == 0 # run at midnight
    
    # archive all messages older than 1 month, set all other emails to mark as read
    puts "archiving 1 month old emails..."
    # rake themessage_archive
    puts "done."

    puts "Sending schedule reminders..."
    Schedule.send_reminders
    puts "done."

    puts "Sending schedule results reminders ..."
    Schedule.send_results
    puts "done."
  end

end
