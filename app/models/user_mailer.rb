class UserMailer < ActionMailer::Base
  def signup_notification(user)
    recipients "#{user.name} <#{user.email}>"
    from       "My Forum "
    subject    "Please activate your new account"
    sent_on    Time.now
    body       :user => user #{ :user => user, :url => activate_url(user.activation_code), :host => user.site.host }
  end

  default_url_options[:host] = "thepista.local"  

  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    from          "Binary Logic Notifier "  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end  
end
