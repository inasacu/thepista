class Invitation < ActiveRecord::Base

  belongs_to      :user
  belongs_to      :item,           :polymorphic => true

  # validations
  validates_presence_of   :user
  validates_presence_of   :email_addresses
  validates_length_of     :email_addresses, :minimum => 6
  validates_length_of     :email_addresses, :maximum => 1500

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

  after_save :send_invite_contact

  def sender
    self.user
  end

  def recipient
    self.email_addresses
  end

  def email
    self.email_addresses
  end

  protected
  def send_invite_contact
    UserMailer.send_later(:deliver_signup_invitation, self)
    UserMailer.deliver_signup_invitation(self)
  end

end