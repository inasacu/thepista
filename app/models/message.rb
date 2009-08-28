class Message < ActiveRecord::Base

  # accessible attributes
  attr_accessor :reply, :parent, :send_mail
  attr_accessible :subject, :body, :parent_id
  
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => 'User', :foreign_key => 'recipient_id'
  belongs_to :conversation
        
  validates_presence_of   :subject, :body
   
  before_create   :assign_conversation
  after_create    :update_recipient_last_contacted_at,
                  :save_recipient, :set_replied_to, :send_receipt_reminder

  
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
  def trash(user, time=Time.now)
    case user
    when sender
      self.sender_deleted_at = time
    when recipient
      self.recipient_deleted_at = time
    else
      # Given our controller before filters, this should never happen...
      raise ArgumentError, I18n.t(:unauthorized_user)
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
      !sender_deleted_at.nil? and sender_deleted_at > User::TRASH_TIME_AGO
    when recipient
      !recipient_deleted_at.nil? and recipient_deleted_at > User::TRASH_TIME_AGO
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
  def mark_as_read(time = Time.now)
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
   
    # Assign the conversation id.
    # This is the parent message's conversation unless there is no parent,
    # in which case we create a new conversation.
    def assign_conversation
      self.conversation = parent.nil? ? Conversation.create : parent.conversation
    end
  
    # Mark the parent message as replied to if the current message is a reply.
    def set_replied_to
      if reply?
        parent.replied_at = Time.now
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
      return if sender == recipient
      @send_mail ||= recipient.message_notification?
      UserMailer.deliver_message_notification(self) if @send_mail
    end
    
    def send_schedule_reminder()
      return if sender == recipient
      @send_mail ||= recipient.message_notification?
      UserMailer.deliver_message_notification(self) if @send_mail
    end

end
