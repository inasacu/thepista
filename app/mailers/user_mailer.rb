class UserMailer < ActionMailer::Base
	default :from => "support@haypista.com"
	# default :from => "[HayPista] <support@haypista.com>"

	def invitation(invitation)		
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
		@message 						= invitation.message
		@url 								= signup_url
	  email_with_name 		= "#{invitation.user.name} <#{invitation.user.email}>"
	
		mail(:from => email_with_name, :to => invitation.email_addresses, :subject => @subject)
	end
	
  def signup_notification(user)
		@user 							= user
    @subject    				= I18n.t(:account_activation)
	  email_with_name 		= "#{user.name} <#{user.email}>"
	
		mail(:to => email_with_name, :subject => @subject)
  end
  
  def password_reset_instructions(user)  
		@user 							= user
    @subject    				= I18n.t(:password_recover_instructions)
		@token							= user.perishable_token  
	  email_with_name 		= "#{user.name} <#{user.email}>"
	
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
	  email_with_name 		= "#{sender.name} <#{sender.email}>"
	
		mail(:to => email_with_name, :subject => @subject)
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
	  email_with_name 		= "#{sender.name} <#{sender.email}>"
	
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
		
		@user      					= sender
		@teammate  					= teammate
		@subject 						= "[HayPista] #{I18n.t(:request_petition)} #{I18n.t(:to_join_email)} -  #{teammate.item.name} "
		@item								= teammate.item
	  email_with_name 		= "#{sender.name} <#{sender.email}>"
	
		mail(:to => email_with_name, :subject => @subject)
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
	  email_with_name 		= "#{sender.name} <#{sender.email}>"
	
		mail(:to => email_with_name, :subject => @subject)    
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
	  email_with_name 		= "#{sender.name} <#{sender.email}>"
	
		mail(:to => email_with_name, :subject => @subject)
  end

  def message_notification(message)
    # I18n.locale = message.sender.language
  
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
    @recipients       	= message.recipient.email
	  email_with_name 		= "#{message.sender.name} <#{message.sender.email}>"
	
		mail(:to => email_with_name, :subject => @subject)    
  end

end
