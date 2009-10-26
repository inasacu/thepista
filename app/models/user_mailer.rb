class UserMailer < ActionMailer::Base
  def signup_notification(user)
    recipients "#{user.name} <#{user.email}>"
    from       "[HayPista] <support@haypista.com>"
    subject    I18n.t(:users_activate)
    sent_on    Time.zone.now
    body       :user => user #{ :user => user, :url => activate_url(user.activation_code), :host => user.site.host }
  end

  default_url_options[:host] = "thepista.local"  

  def password_reset_instructions(user)  
    subject       I18n.t(:password_recover_instructions)
    from          "[HayPista] <support@haypista.com>"
    recipients    user.email  
    sent_on       Time.zone.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end    

  def signup_invitation(email, user, message)
    @recipients = "#{email}"
    @subject = "#{user.name} #{I18n.t(:invitation_to_join)}!"
    @sent_on = Time.zone.now
    @body[:user] = user
    @body[:url] = signup_url
    @body[:message] = message
    @from  =  "#{user.name} <#{user.email}>"
    content_type  "text/html"
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
  
  protected
  def setup_message_email(message)
    @subject          = message.subject
    @recipients       = message.recipient.email
    @from             = "#{message.sender.name} <#{message.sender.email}>"
    @sent_on          = Time.zone.now
    @body[:user]      = message.sender
    @body[:message]   = message
    @body[:url]       = "thepista.local"
    @content_type     = "text/html"
    # @headers          = {}
  end

end
