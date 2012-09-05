# TABLE "messages"
# t.string   "subject"                    
# t.text     "body"
# t.integer  "parent_id"
# t.integer  "ser_id"
# t.integer  "recipient_id"
# t.integer  "conversation_id"
# t.integer  "reply_id"
# t.datetime "replied_at"
# t.datetime "ser_deleted_at"
# t.datetime "ser_read_at"
# t.datetime "recipient_deleted_at"
# t.datetime "recipient_read_at"
# t.integer  "replies"                                   
# t.integer  "reviews"                                   
# t.boolean  "archive"                                   
# t.datetime "created_at"
# t.datetime "updated_at"
# t.integer  "item_id"
# t.string   "item_type"
# t.integer  "received_messageable_id"
# t.string   "received_messageable_type"
# t.integer  "sent_messageable_id"
# t.string   "sent_messageable_type"
# t.boolean  "opened"                                    
# t.boolean  "recipient_delete"                          
# t.boolean  "ser_delete"                             
# t.string   "ancestry"
# t.boolean  "recipient_permanent_delete"                
# t.boolean  "ser_permanent_delete"

class Message < ActiveRecord::Base

  # accessible attributes
  attr_accessor :reply, :parent, :send_mail
  attr_accessible :subject, :body, :parent_id

  belongs_to :sender,         :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :recipient,      :class_name => 'User', :foreign_key => 'recipient_id'
  belongs_to :conversation
  belongs_to :item,           :polymorphic => true

  validates_presence_of   :subject #, :body

  before_create   :assign_conversation, :format_body
  after_create    :update_recipient_last_contacted_at, :save_recipient, :set_replied_to, :send_receipt_reminder, :send_schedule_reminder


  # Return all messages in the same parent group          
  def self.find_all_parent_messages(parent_id)
    find(:all, :conditions => ["parent_id = (select parent_id from messages where id = ?)", parent_id])
  end

  def parent
    return @parent unless @parent.nil?
    return Message.find(parent_id) unless parent_id.nil?
  end

  def parent=(message)
    self.parent_id = message.id
    @parent = message
  end

  # Return the sender/recipient that *isn't* the given user.
  def other_user(user)
    user == sender ? recipient : sender
  end

  # Put the message in the trash for the given user.
  def trash(user, time=Time.zone.now)

    case user
    when sender
      self.sender_deleted_at = time
    when recipient
      self.recipient_deleted_at = time
    else
      # Given our controller before filters, this should never happen...
      # raise ArgumentError, I18n.t(:unauthorized_user)
    end

    if sender == recipient
      self.sender_deleted_at = time
      self.recipient_deleted_at = time
    end
    save!
  end


  # Move the message back to the inbox.
  def untrash(user)
    return false unless trashed?(user)
    trash(user, nil)
  end

  # Return true if the message has been trashed.
  def trashed?(user)
    case user
    when sender
      !sender_deleted_at.nil? and sender_deleted_at > User::ONE_MONTH_AGO
    when recipient
      !recipient_deleted_at.nil? and recipient_deleted_at > User::ONE_MONTH_AGO
    end
  end

  # Return true if the message is a reply to a previous message.
  def reply?
    (!parent.nil? or !parent_id.nil?) and valid_reply?
  end

  # Return true if the sender/recipient pair is valid for a given parent.
  def valid_reply?
    # People can send multiple replies to the same message, in which case
    # the recipient is the same as the parent recipient.
    # For most replies, the message recipient should be the parent sender.
    # We use Set to handle both cases uniformly.
    Set.new([sender, recipient]) == Set.new([parent.sender, parent.recipient])
  end

  # Return true if pair of people is valid.
  def valid_reply_pair?(user, other)
    ((recipient == user and sender == other) or
    (recipient == other and sender == user))
  end

  # Return true if the message has been replied to.
  def replied_to?
    !replied_at.nil?
  end

  # Return true if the message is new for the given user.
  def new?(user)
    not read? and user != sender
  end

  # Mark a message as read.
  def mark_as_read(time = Time.zone.now)
    unless read?
      self.recipient_read_at = time
      save!
    end
  end

  # Return true if a message has been read.
  def read?
    !recipient_read_at.nil?
  end

  private

  def format_body
    self.body.gsub!(/\r?\n/, "<br>") unless self.body.nil?
  end

  # Assign the conversation id.
  # This is the parent message's conversation unless there is no parent,
  # in which case we create a new conversation.
  def assign_conversation
    self.conversation = parent.nil? ? Conversation.create : parent.conversation
  end

  # Mark the parent message as replied to if the current message is a reply.
  def set_replied_to
    if reply?
      parent.replied_at = Time.zone.now
      parent.save!
    end
  end

  def update_recipient_last_contacted_at
    self.recipient.last_contacted_at = updated_at
  end

  def save_recipient
    self.recipient.save!
  end

  def send_receipt_reminder
    return if (sender == recipient or !self.item_type.nil?)
    @send_mail ||= recipient.message_notification?   
    return unless @send_mail
    UserMailer.delay.message_notification(self) 
  end

  def send_schedule_reminder
    return if (self.item_type.nil?)

    @send_mail ||= recipient.teammate_notification?   
    return unless @send_mail

    case self.item.class.to_s      
    when "Schedule", "Match", "Scorecard"
      UserMailer.delay.message_schedule(self)
    else
      return
    end

  end

  def self.archive_messages    
    the_archive_messages = []  
    message_counter = 1 

    @archive_messages = Message.find(:all, :conditions => ["created_at <= ? and parent_id is null", TIME_WEEK_AGO])
    @archive_messages.each {|message| the_archive_messages << message}

    # archive all messages older than 1 week, any scorecard or scheduls
    the_archive_messages.each do |message|

      puts "ARCHIVE MESSAGE W/O PARENT ID #{message.id}, #{message.conversation_id} - message removed (#{message_counter})"
      message.destroy
      message_counter += 1

    end

    @archive_messages = Message.find(:all, :select => "distinct parent_id", :conditions => ["created_at <= ?", TIME_WEEK_AGO])
    @archive_messages.each {|message| the_archive_messages << message}

    # archive all messages older than 1 week, any scorecard or scheduls
    the_archive_messages.each do |archive|

      @parent_messages = Message.find_all_parent_messages(archive.parent_id)
      @parent_messages.each do |message|

        puts "ARCHIVE MESSAGE W PARENT ID #{message.id}, #{message.parent_id}, #{message.conversation_id} - message removed (#{message_counter})"
        message.destroy
        message_counter += 1

      end
    end

    Conversation.find(:all, :conditions => ["id not in (select conversation_id from messages)"]).each do |conversation|
      puts "#{conversation.id} #{conversation.created_at} - conversation removed (#{message_counter})"
      conversation.destroy
      message_counter += 1
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


    the_archive_messages = []

    @archive_messages = Message.find(:all, :conditions => ["item_type = 'Scorecard'"])
    @archive_messages.each {|message| the_archive_messages << message}

    @archive_messages = Message.find(:all, :conditions => ["item_type = 'Schedule'"])
    @archive_messages.each {|message| the_archive_messages << message}


    the_archive_messages.each do |message|
      puts "#{message.id}, #{message.item_type} - message removed (#{message_counter})"
      message.destroy
      message_counter += 1
    end
  end

end
