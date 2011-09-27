class UserMailer < ActionMailer::Base

  default_url_options[:host] = "haypista.com"
  helper ActionView::Helpers::UrlHelper
  helper ActionView::Helpers::TagHelper

  def signup_notification(user)
    recipients "#{user.name} <#{user.email}>"
    from       "[HayPista] <support@haypista.com>"
    subject    I18n.t(:users_activate)
    sent_on    Time.zone.now
    body       :user => user 
  end

  def password_reset_instructions(user)  
    subject       I18n.t(:password_recover_instructions)
    from          "[HayPista] <support@haypista.com>"
    recipients    user.email  
    sent_on       Time.zone.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end 

  def teammate_join(teammate, recipient, sender)
    the_subject = "[HayPista] #{I18n.t(:request_petition)} #{I18n.t(:to_join_email)} - "
    if teammate.group
      @subject          = "#{the_subject} #{teammate.group.name} " 
      @body[:group]     = teammate.group 
    end
    @recipients       = recipient.email
    @from             = "#{sender.name} <#{sender.email}>"
    @sent_on          = Time.zone.now
    @body[:teammate]  = teammate
    @body[:user]      = sender
    @content_type     = "text/html"
  end 

  def teammate_leave(teammate, recipient, sender)
    the_subject = "[HayPista] #{I18n.t(:petition_to_join_declined)} - "
    if teammate.group
      @subject          = "#{the_subject} #{teammate.group.name} " 
      @body[:group]     = teammate.group 
    end
    @recipients       = recipient.email
    @from             = "#{sender.name} <#{sender.email}>"
    @sent_on          = Time.zone.now
    @content_type     = "text/html"
  end

  def manager_join_item(teammate, recipient, sender)
    the_subject = "[HayPista] #{I18n.t(:request_petition)} #{I18n.t(:to_join_email)} - "

    @subject          = "#{the_subject} #{teammate.item.name} " 
    @body[:item]     = teammate.item
    @recipients       = recipient.email
    @from             = "#{sender.name} <#{sender.email}>"
    @sent_on          = Time.zone.now
    @body[:teammate]  = teammate
    @body[:user]      = sender
    @content_type     = "text/html"
  end 

  def manager_leave_item(teammate, recipient, sender)
    the_subject = "[HayPista] #{I18n.t(:petition_to_join_declined)} - "
    
    @subject          = "#{the_subject} #{teammate.item.name} " 
    @body[:item]     = teammate.item
    @recipients       = recipient.email
    @from             = "#{sender.name} <#{sender.email}>"
    @sent_on          = Time.zone.now
    @content_type     = "text/html"
  end
  
  def message_blog(recipient, user, message, label="")
    label = "#{label} - " unless label.blank?
    @recipients = recipient.email
    @subject = "#{label}#{I18n.t(:comments_on_blog)}!"
    @sent_on = Time.zone.now
    @body[:user] = user
    @body[:message] = message
    @body[:recipient] = recipient
    @from  =  "#{user.name} <#{user.email}>"
    sent_on       Time.zone.now
    content_type  "text/html"
  end

  def message_notification(message)
    I18n.locale = message.sender.language
    setup_message_email(message)
  end

  def message_schedule(message)
    I18n.locale = message.sender.language
    setup_message_email(message)
  end

  def signup_invitation(invitation)
    # I18n.locale = message.sender.language
    setup_invitation_email(invitation)
  end

  protected
  def setup_invitation_email(invitation)

    case invitation.item.class.to_s 
    when "Group"
      @subject            = "#{I18n.t(:groups_join)} #{invitation.item.name}"
      @body[:group]       = invitation.item
    when "Schedule"
      @subject            = "#{invitation.user.name} #{I18n.t(:participate_schedule)}!"
      @body[:schedule]    = invitation.item
    when "Challenge"
      @subject            = "#{invitation.user.name} #{I18n.t(:participate_challenge)}!"
      @body[:challenge]   = invitation.item
    when "Cup"
      @subject            = "#{invitation.user.name} #{I18n.t(:participate_cup)}!"
      @body[:cup]         = invitation.item
    else
      @subject            = "#{invitation.user.name} #{I18n.t(:invitation_to_join)}!"
    end

    @recipients       = "#{invitation.email}"
    @from             = "#{invitation.user.name} <#{invitation.user.email}>"
    @sent_on          = Time.zone.now
    @body[:user]      = invitation.user
    @body[:message]   = invitation
    @body[:url]       = signup_url
    @content_type     = "text/html"
  end

  def setup_message_email(message)

    case message.item.class.to_s 
    when "Group"
      @body[:group]       = message.item
    when "Schedule"
      @body[:schedule]    = message.item
      @body[:recipient]   = message.recipient
    when "Scorecard"
      @body[:scorecard]    = message.item
    end

    @subject          = message.subject
    @recipients       = message.recipient.email
    @from             = "#{message.sender.name} <#{message.sender.email}>"
    @sent_on          = Time.zone.now
    @body[:user]      = message.sender
    @body[:message]   = message
    @body[:url]       = "haypista.com"
    @content_type     = "text/html"
  end

end
