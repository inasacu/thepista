class UserMailer < ActionMailer::Base
  def signup_notification(user)
    recipients "#{user.name} <#{user.email}>"
    from       "My Forum "
    subject    I18n.t(:users_activate)
    sent_on    Time.now
    body       :user => user #{ :user => user, :url => activate_url(user.activation_code), :host => user.site.host }
  end

  default_url_options[:host] = "thepista.local"  

  def password_reset_instructions(user)  
    subject       I18n.t(:password_recover_instructions)
    from          "Binary Logic Notifier "  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end  

  # def message(mail)
  #   recipients    mail[:email]
  #   subject       "[HayPista] " + mail[:message].subject
  #   body          mail
  #   from          mail[:user].name +  '  <DoNotReply@haypista.com>'
  #   content_type  "text/html"
  # end 
  
  # def manager_request(mail)
  #   subject     "#{I18n.t(:join_group)} " + mail[:group].name
  #   from        mail[:user].name +  '  <DoNotReply@haypista.com>'
  #   recipients  mail[:email]
  #   body        mail
  #   content_type  "text/html"
  # end  
  
  # def manager_join(mail)
  #   subject     "#{I18n.t(:to_join_group_message) } " + mail[:group].name
  #   from        mail[:user].name +  '  <DoNotReply@haypista.com>'
  #   recipients  mail[:email]
  #   body        mail
  #   content_type  "text/html"
  # end 
  
  # def manager_leave(mail)
  #   subject     "#{I18n.t(:to_leave_group_message)}  " + mail[:group].name
  #   from        mail[:user].name +  '  <DoNotReply@haypista.com>'
  #   recipients  mail[:email]
  #   body        mail
  #   content_type  "text/html"
  # end 
  
  # def message_group(mail)
  #   subject     "#{I18n.t(:join_group)} [#{mail[:group].name}]"
  #   from        mail[:user].name +  '  <DoNotReply@haypista.com>'
  #   recipients  mail[:email]
  #   body        mail
  #   content_type  "text/html"
  # end  
  
  def message_match(mail)
    subject     "#{I18n.t(:matches)} [#{mail[:group].name}] - #{mail[:schedule].concept}"
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

  def message_notification(message)
    subject       "[HayPista] " + message.subject
    from          "<DoNotReply@haypista.com>"
    recipients    message.recipient.email
    body          message.body
    content_type  "text/html"

    # from         "Message notification <message@#{domain}>"
    # recipients   message.recipient.email
    # subject      formatted_subject("New message")
    # body         "server" => server, "message" => message,
    #              "preferences_note" => preferences_note(message.recipient)
  end

end
