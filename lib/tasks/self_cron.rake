# to run:    sudo rake self_cron

desc "set reminder dates to schedules 3 days before"
task :self_cron => :environment do

  puts "Hour:  #{Time.zone.now.hour}"
  puts "TIME zone now:  #{Time.zone.now}"
  puts "Time now:  #{Time.now}"

  # puts "archive all messages older than 1 month, set all other emails to mark as read..."
  # # rake the_message_archive
  # puts "done."

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

  puts "Sitemap Refresh..."
  Rake::Task['sitemap:refresh'].invoke


  ActiveRecord::Base.establish_connection(RAILS_ENV.to_sym)

  @archive_messages = Message.find(:all, :select => "distinct parent_id", :conditions => ["created_at <= ?", 1.month.ago])
  @archive_messages.each do |archive|
    @parent_messages = Message.find_all_parent_messages(archive.parent_id)
    @parent_messages.each do |message|
      puts "#{message.id}, #{message.parent_id}, #{message.conversation_id} - message removed"
      message.destroy
    end
  end

  Conversation.find(:all, :conditions => ["id not in (select conversation_id from messages)"]).each do |conversation|
    puts "#{conversation.id} #{conversation.created_at} - conversation removed"
    conversation.destroy
  end

  Message.find(:all, :conditions => ["sender_read_at is null"]).each do |message|
    message.sender_read_at = Time.zone.now
    message.save!
    puts "#{message.created_at} - mark as red"
  end

  Message.find(:all, :conditions => ["recipient_read_at is null"]).each do |message|
    message.recipient_read_at = Time.zone.now
    message.save!
    puts "#{message.created_at} - mark as red"
  end

end
