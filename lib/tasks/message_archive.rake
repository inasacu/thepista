# to run:    sudo rake the_message_archive

desc "archive all messages older than 1 month, set all other emails to mark as read"
task :the_message_archive => :environment do |t|

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

