class UserMailer < ActionMailer::Base

  default_url_options[:host] = "haypista.com"

  def signup_notification(user)
    recipients "#{user.name} <#{user.email}>"
    from       "[HayPista] <support@haypista.com>"
    subject    I18n.t(:users_activate)
    sent_on    Time.zone.now
    body       :user => user #{ :user => user, :url => activate_url(user.activation_code), :host => user.site.host }
  end

  def password_reset_instructions(user)  
    subject       I18n.t(:password_recover_instructions)
    from          "[HayPista] <support@haypista.com>"
    recipients    user.email  
    sent_on       Time.zone.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end  

  def manager_join(mail)
    subject       "[HayPista] #{I18n.t(:to_join_group_message) } " + mail[:group].name
    from          "#{mail[:user].name} <#{mail[:user].email}>"
    recipients    mail[:email]
    body          mail
    sent_on       Time.zone.now
    content_type  "text/html"
  end 

  def manager_leave(mail)
    subject       "[HayPista] #{I18n.t(:to_leave_group_message)}  " + mail[:group].name
    from          "#{mail[:user].name} <#{mail[:user].email}>"
    recipients    mail[:email]
    body          mail
    sent_on       Time.zone.now
    content_type  "text/html"
  end 

  def message_blog(recipient, user, message)
    @recipients = recipient.email
    @subject = "#{user.name}  #{I18n.t(:comments_on_your_blog)}!"
    @sent_on = Time.zone.now
    @body[:user] = user
    @body[:message] = message
    @from  =  "#{user.name} <#{user.email}>"
    sent_on       Time.zone.now
    content_type  "text/html"
  end

  def message_notification(message)
    setup_message_email(message)
  end

  def message_schedule(message)
    setup_message_email(message)
  end

  def signup_invitation(invitation)
    setup_invitation_email(invitation)
  end
  
  protected
  def setup_invitation_email(invitation)
    
    case invitation.item.class.to_s 
    when "Group"
      @subject            = "#{invitation.user.name} #{I18n.t(:participate_group)}!"
      @body[:group]       = invitation.item
    when "Schedule"
      @subject            = "#{invitation.user.name} #{I18n.t(:participate_schedule)}!"
      @body[:schedule]    = invitation.item
    else
      @subject            = "#{invitation.user.name} #{I18n.t(:invitation_to_join)}!"
    end
    
    
    @recipients       = "#{invitation.email}"
    @from             = "#{invitation.user.name} <#{invitation.user.email}>"
    @sent_on          = Time.zone.now
    @body[:user]      = invitation.user
    @body[:message]   = message
    @body[:url]       = signup_url
    @content_type     = "text/html"
    # @headers          = {}
  end

  def setup_message_email(message)
    @subject          = message.subject
    @recipients       = message.recipient.email
    @from             = "#{message.sender.name} <#{message.sender.email}>"
    @sent_on          = Time.zone.now
    @body[:user]      = message.sender
    @body[:message]   = message
    @body[:url]       = "haypista.com"
    @content_type     = "text/html"
    # @headers          = {}
  end

end
