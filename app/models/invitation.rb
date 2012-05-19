class Invitation < ActiveRecord::Base

  belongs_to      :user
  belongs_to      :item,           :polymorphic => true

  # validations
  validates_presence_of     :user
  validates_presence_of     :email_addresses
  validates_length_of       :email_addresses, :minimum => 6
  validates_length_of       :email_addresses, :maximum => 255
  validates_presence_of     :message
  validates_length_of       :message,     :within => DESCRIPTION_RANGE_LENGTH

  validates_each :email_addresses do |record, attr, email_addresses |
    invalid_emails = []
    email_addresses = email_addresses || ''
    emails = email_addresses.split(",").collect{|email| email.strip }.uniq
  
    emails.each{ |email|
      unless email =~ /[\w._%-]+@[\w.-]+.[a-zA-Z]{2,4}/
        invalid_emails << email
      end
    }
    unless invalid_emails.empty?
      record.errors.add(:email_addresses, " included invalid addresses: <ul>"+invalid_emails.collect{|email| '<li>'+email+'</li>' }.join+"</ul>")
      record.email_addresses = (emails - invalid_emails).join(', ')
    end
  end
  
  # variables to access
  # attr_accessible :email_addresses, :message, :user_id, :item_id, :item_type
    
  before_create :format_message
  after_save :send_invite_contact

  def self.email_to_name(email)
    contact = email[/[^@]+/]
    contact.split(".").map {|n| n.capitalize }.join(" ")
    return contact
  end
  
  def sender
    self.user
  end

  def recipient
    self.email_addresses
  end

  def email
    self.email_addresses
  end
  
  def format_message
    self.message.gsub!(/\r?\n/, "<br>") unless self.message.nil?
  end  
    
  def self.contact_emails(email)
    Invitation.find(:first, :conditions => ["email_addresses = ?", email])
  end
  
  def self.has_sent_invitation(user)
    if self.count(:conditions => ["user_id = ? and created_at >= ?", user.id, SIX_MONTHS_AGO]) > 0
      return true
    end
    return false
  end

  protected
  def send_invite_contact
    UserMailer.invitation(self).deliver
	  # UserMailer.welcome_email(self.user).deliver
  end

end