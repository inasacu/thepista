class UserMailer < ActionMailer::Base
  default :from => "support@haypista.com"

  layout 'mailer_zurb' 
  helper ApplicationHelper

  def registration_confirmation(user)
    mail(:to => launch.email, :subject => "Registered with HayPista!")
  end


  def invitation(invitation)	

    @is_from_widget = invitation.is_from_widget
    @widget_host = invitation.widget_host

    case invitation.item.class.to_s 
    when "Group"
      @subject					= "#{I18n.t(:groups_join)} #{invitation.item.name}"
      @group      			= invitation.item
    when "Schedule"
      @subject        	= "#{invitation.user.name} #{I18n.t(:participate_schedule)}!"
      @schedule    			= invitation.item
    when "Challenge"
      @subject					= "#{invitation.user.name} #{I18n.t(:participate_challenge)}!"
      @challenge   			= invitation.item
    when "Cup"
      @subject        	= "#{invitation.user.name} #{I18n.t(:participate_cup)}!"
      @cup         			= invitation.item
    else
      @subject        	= "#{invitation.user.name} #{I18n.t(:invitation_to_join)}!"			
    end

    @user 							= invitation.user
    @invitation					= invitation		
    email_with_name 		= "#{invitation.user.name} <#{invitation.user.email}>"

    I18n.locale = @user.language unless @user.language.blank?

    mail(:from => email_with_name, :to => invitation.email_addresses, :subject => @subject)
  end

  def signup_notification(user)
    @user 							= user
    @subject    				= @user.confirmation_token.nil? ? I18n.t(:account_activation) : I18n.t(:account_created_short)
    email_with_name 		= "#{user.name} <#{user.email}>"
    I18n.locale = @user.language unless @user.language.blank?
    mail(:to => email_with_name, :subject => @subject)
  end

  def activation_reset(user)
    @user 							= user
    @subject    				= I18n.t(:account_created_short)
    email_with_name 		= "#{user.name} <#{user.email}>"
    I18n.locale = @user.language unless @user.language.blank?
    mail(:to => email_with_name, :subject => @subject)
  end 

  def teammate_join(teammate, recipient, sender)
    case teammate.item.class.to_s 
    when "Group"
      @group      			= teammate.item
      @automatic_petition			= teammate.item.automatic_petition
    when "Schedule"
      @schedule    			= teammate.item
    when "Challenge"
      @challenge   			= teammate.item
    when "Cup"
      @cup         			= teammate.item	
    end

    @user								= sender
    @teammate						= teammate
    @subject						= "[HayPista] #{I18n.t(:request_petition)} #{I18n.t(:to_join_email)} -  #{teammate.item.name} "
    @item								= teammate.item

    to_email_with_name 			= "#{recipient.name} <#{recipient.email}>"
    from_email_with_name 		= "#{sender.name} <#{sender.email}>"

    I18n.locale = @user.language unless @user.language.blank?

    mail(:to => to_email_with_name, :subject => @subject, :from => from_email_with_name)
  end 

  def manager_join_item(teammate, recipient, sender)
    case teammate.item.class.to_s 
    when "Group"
      @group      			= teammate.item
      @automatic_petition			= teammate.item.automatic_petition 
    when "Schedule"
      @schedule    			= teammate.item
    when "Challenge"
      @challenge   			= teammate.item
    when "Cup"
      @cup         			= teammate.item	
    end

    @user      					= sender
    @teammate  					= teammate
    @subject 						= "[HayPista] #{I18n.t(:request_petition)} #{I18n.t(:to_join_email)} -  #{teammate.item.name} "
    @item								= teammate.item

    to_email_with_name 			= "#{recipient.name} <#{recipient.email}>"
    from_email_with_name 		= "#{sender.name} <#{sender.email}>"

    I18n.locale = @user.language unless @user.language.blank?

    mail(:to => to_email_with_name, :subject => @subject, :from => from_email_with_name)
  end


  def teammate_join(teammate, recipient, sender)
    case teammate.item.class.to_s 
    when "Group"
      @group      			= teammate.item
      @automatic_petition			= teammate.item.automatic_petition 
    when "Schedule"
      @schedule    			= teammate.item
    when "Challenge"
      @challenge   			= teammate.item
    when "Cup"
      @cup         			= teammate.item	
    end

    @user      					= sender
    @teammate  					= teammate
    @subject 						= "[HayPista] #{I18n.t(:request_petition)} #{I18n.t(:to_join_email)} -  #{teammate.item.name} "
    @item								= teammate.item

    to_email_with_name 			= "#{recipient.name} <#{recipient.email}>"
    from_email_with_name 		= "#{sender.name} <#{sender.email}>"

    I18n.locale = @user.language unless @user.language.blank?

    mail(:to => to_email_with_name, :subject => @subject, :from => from_email_with_name)
  end 

  def teammate_leave(teammate, recipient, sender)
    case teammate.item.class.to_s 
    when "Group"
      @group      			= teammate.item
      @automatic_petition			= teammate.item.automatic_petition 
    when "Schedule"
      @schedule    			= teammate.item
    when "Challenge"
      @challenge   			= teammate.item
    when "Cup"
      @cup         			= teammate.item	
    end

    @user      					= sender
    @teammate  					= teammate
    @subject 						= "[HayPista] #{I18n.t(:petition_to_join_declined)} -  #{teammate.item.name} "
    @item								= teammate.item

    to_email_with_name 			= "#{recipient.name} <#{recipient.email}>"
    from_email_with_name 		= "#{sender.name} <#{sender.email}>"

    I18n.locale = @user.language unless @user.language.blank?

    mail(:to => to_email_with_name, :subject => @subject, :from => from_email_with_name)  
  end

  def manager_leave_item(teammate, recipient, sender)
    case teammate.item.class.to_s 
    when "Group"
      @group      			= teammate.item
      @automatic_petition			= teammate.item.automatic_petition 
    when "Schedule"
      @schedule    			= teammate.item
    when "Challenge"
      @challenge   			= teammate.item
    when "Cup"
      @cup         			= teammate.item	
    end

    @user      					= sender
    @teammate  					= teammate
    @subject 						= "[HayPista] #{I18n.t(:petition_to_join_declined)} -  #{teammate.item.name} "
    @item								= teammate.item

    to_email_with_name 			= "#{recipient.name} <#{recipient.email}>"
    from_email_with_name 		= "#{sender.name} <#{sender.email}>"

    I18n.locale = @user.language unless @user.language.blank?

    mail(:to => to_email_with_name, :subject => @subject, :from => from_email_with_name)
  end

  def message_notification(message)

    case message.item.class.to_s 
    when "Group"
      @group       			= message.item
    when "Schedule"
      @schedule   			= message.item
      @recipient   			= message.recipient
    when "Scorecard"
      @scorecard    		= message.item
    end

    @user      					= message.sender
    @message   					= message

    @subject          	= message.subject
    @recipients					= []
    @recipients       	= message.recipient.email unless message.recipient.email


    to_email_with_name 			= "#{message.recipient.name} <#{message.recipient.email}>"
    from_email_with_name 		= "#{message.sender.name} <#{message.sender.email}>"

    I18n.locale = @user.language unless @user.language.blank?

    mail(:to => to_email_with_name, :subject => @subject, :from => from_email_with_name)    
  end

  def message_schedule(message)
    message_notification(message)
  end

end
