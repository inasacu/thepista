class UserMailer < ActionMailer::Base
  def signup_notification(user)
    recipients "#{user.name} <#{user.email}>"
    from       "[HayPista]"
    subject    I18n.t(:users_activate)
    sent_on    Time.zone.now
    body       :user => user #{ :user => user, :url => activate_url(user.activation_code), :host => user.site.host }
  end

  default_url_options[:host] = "thepista.local"  

  def password_reset_instructions(user)  
    subject       I18n.t(:password_recover_instructions)
    from          "[HayPista]"  
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
      @from  =  user.name + '  <DoNotReply@haypista.com>'
      content_type  "text/html"
  end
  
  def manager_join(mail)
    subject     "[HayPista] #{I18n.t(:to_join_group_message) } " + mail[:group].name
    from        mail[:user].name +  '  <DoNotReply@haypista.com>'
    recipients  mail[:email]
    body        mail
    content_type  "text/html"
  end 
  
  def manager_leave(mail)
    subject     "[HayPista] #{I18n.t(:to_leave_group_message)}  " + mail[:group].name
    from        mail[:user].name +  '  <DoNotReply@haypista.com>'
    recipients  mail[:email]
    body        mail
    content_type  "text/html"
  end 
  
  def message_match(mail)
    subject     "#{I18n.t(:matches)} #{mail[:schedule].concept}"
    from        mail[:user].name +  '  <DoNotReply@haypista.com>'
    recipients  mail[:email]
    body        mail
    content_type  "text/html"
  end 
  
  def message_scorecard(mail)
    subject     "#{I18n.t(:scorecards)} [#{mail[:group].name}]"
    from        mail[:user].name +  '  <DoNotReply@haypista.com>'
    recipients  mail[:email]
    body        mail
    content_type  "text/html"
  end
  
  def message_schedule(mail)
    subject     "#{I18n.t(:schedule)} [#{mail[:group].name}] - #{mail[:schedule].concept}"
    from        mail[:user].name +  '  <DoNotReply@haypista.com>'
    recipients  mail[:email]
    body        mail
    content_type  "text/html"
  end
  
  def message_blog(recipient, user, message)
      @recipients = recipient.email
      @subject = "#{user.name} #{I18n.t(:comments_on_your_blog)}!"
      @sent_on = Time.zone.now
      @body[:user] = user
      @body[:message] = message
      @from  =  user.name + '  <DoNotReply@haypista.com>'
      content_type  "text/html"
  end

  def message_notification(message)
    subject       "[HayPista] " + message.subject
    from          "<DoNotReply@haypista.com>"
    recipients    message.recipient.email
    body          message.body
    content_type  "text/html"
  end

end
