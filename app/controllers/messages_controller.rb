class MessagesController < ApplicationController
	before_filter :require_user

	def index
		@user = User.find(current_user)
		@messages = Message.select("distinct messages.*").where("messages.parent_id is not null and messages.archive = false and ((messages.recipient_id = #{@user.id} and recipient_deleted_at IS NULL) or 
																															(messages.sender_id = #{@user.id} and sender_deleted_at IS NULL)  
																															)").page(params[:page]).order('messages.parent_id, messages.created_at DESC')
		render @the_template
	end

	def show
		store_location
		@messages = Message.find_all_parent_messages(params[:id])

		set_the_template('messages/index')
		render @the_template   
	end

	def new
		@message = Message.new

		if (params[:id])
			@recipient = User.find(params[:id])

		elsif (params[:recipient_id])
			@recipients = User.find(params[:recipient_id])

		elsif (params[:group_id])
			@group = Group.find(params[:group_id])
			@recipients = User.find_group_mates(@group)

			if params[:roster_id]
				users = []
				@the_schedule = Schedule.find(params[:roster_id])
				@recipients = User.squad_list(@the_schedule)
			end

		elsif (params[:schedule_id])
			@schedule = Schedule.find(params[:schedule_id])
			@group = @schedule.group
			@recipients = User.squad_list(@schedule)   
			  
			@message.body = @schedule.name
			@message.subject = @schedule.name

		elsif (params[:match_id])
			@match = Match.find(params[:match_id])
			@schedule = @match.schedule
			@group = @schedule.group
			@recipients = User.squad_list(@schedule)
			  
			@message.body = @schedule.name
			@message.subject = @schedule.name

		elsif (params[:scorecard_id])
			@scorecard = Schedule.find(params[:scorecard_id])
			@group = @scorecard.group
			@recipients = User.find_group_mates(@group)   
			  
			@message.subject = "#{@group.name} - #{I18n.t(:send_scorecard_subject)}"

		elsif (params[:challenge_id])
			@challenge = Challenge.find(params[:challenge_id])
			@recipients = @challenge.users
			  
			@message.body = @challenge.name
			@message.subject = @challenge.name

		else
			@recipients = User.find_all_by_mates(current_user)
		end

		render @the_template  
	end

	def reply
		@the_message = Message.find(params[:block_token])
		@the_sender = @the_message.sender

		@user = User.find(current_user)
		reply_message = @the_message
		@recipients = current_user.find_user_in_conversation(reply_message) 
		
		unless @recipients.nil?
			@message = Message.new      
			@message.body = reply_message.body.gsub('<br>', ' ')
			@message.subject = reply_message.subject
			@message.sender = current_user

			@messages = Message.find(:all, :conditions => ["messages.sender_deleted_at is not null or messages.recipient_deleted_at is not null"])
			@messages.each do |message|
				message.sender_deleted_at = nil
				message.recipient_deleted_at = nil  
				message.save!
			end
		end

		set_the_template('messages/new')
		render @the_template  
	end

	def create
		@message = Message.new(params[:message])
		@message.sender = current_user

		# message to a single user
		unless params[:recipient][:id].blank?
			@recipient = User.find(params[:recipient][:id])  
			@message.recipient = @recipient

			if @message.save            
				@message.update_attribute('parent_id', @message.id) 
			end

			respond_to do |format|
				flash[:notice] = I18n.t(:message_sent)
				format.html { redirect_to messages_url and return}
			end

		end

		# message to several users    
		if params[:recipient_ids]
			@recipients = User.find(params[:recipient_ids])

			unless params[:schedule][:id].blank?
				@schedule = Schedule.find(params[:schedule][:id]) 
			end

			unless params[:match][:id].blank?
				@match = Match.find(params[:match][:id]) 
			end

			unless params[:scorecard][:id].blank?
				@group = Schedule.find(params[:scorecard][:id]).group 
				@scorecard = @group.scorecards.first
			end


			if @scorecard
				group_messages(@message, @recipients, @scorecard)

			elsif @match
				group_messages(@message, @recipients, @match.schedule)

			elsif @schedule 
				group_messages(@message, @recipients, @schedule)

			else
				recipient_messages(@message, @recipients)
			end


			respond_to do |format|
				flash[:notice] = I18n.t(:message_sent)
				format.html { redirect_to messages_url and return}
			end

		else
			redirect_to :action => 'new' and return
		end

	rescue ActiveRecord::RecordNotSaved
		flash[:notice] = I18n.t(:missing_information)
		redirect_to messages_url and return
	end

	def group_messages(message, recipients, object)    
		parent_id = 0
		parent_id = message.parent_id if reply?

		unless recipients.nil?
			recipients.each do |recipient| 

				@recipient_message = Message.new      
				@recipient_message.subject = message.subject
				@recipient_message.body = message.body
				@recipient_message.sender = current_user
				@recipient_message.recipient = recipient

				@recipient_message.item_type = object.class.to_s
				@recipient_message.item_id = object.id

				if @recipient_message.save 
					parent_id = @recipient_message.id if parent_id == 0            
					@recipient_message.update_attribute('parent_id', parent_id) 
				end

			end
		end
	end

	def recipient_messages(message, recipients)
		parent_id = 0
		parent_id = message.parent_id if reply?

		unless recipients.nil?
			recipients.each do |recipient| 

				@recipient_message = Message.new      
				@recipient_message.subject = message.subject
				@recipient_message.body = message.body
				@recipient_message.sender = current_user
				@recipient_message.recipient = recipient
				# @recipient_message.save!

				if @recipient_message.save 
					parent_id = @recipient_message.id if parent_id == 0            
					@recipient_message.update_attribute('parent_id', parent_id) 
				end

			end
		end
	end

	def trash
		# @block_token = Base64::decode64(params[:block_token].to_s).to_i
		# @messages = Message.find_all_parent_messages(@block_token)
		@messages = Message.find_all_parent_messages(params[:block_token])

		@user = User.find(current_user)
		@messages.each do |message|
			if message.sender == @user
				message.sender_read_at = Time.zone.now
				message.sender_deleted_at = Time.zone.now
				
				if message.recipient == @user
					message.recipient_read_at = Time.zone.now
					message.recipient_deleted_at = Time.zone.now
				end
				
			else
				message.recipient_read_at = Time.zone.now
				message.recipient_deleted_at = Time.zone.now
			end       
			message.save!
		end
		flash[:notice] = I18n.t(:recycled_message)
		redirect_to :action => 'index' and return
	end
	
	private

	def setup
		@body = I18n.t(:messages)
	end

	def authenticate_user
		@message = Message.find(params[:id])
		unless (current_user == @message.sender or
			current_user == @message.recipient)
			redirect_to login_url
		end
	end

	def reply?
		not params[:message][:parent_id].nil?
	end

	# Return the proper recipient for a message.
	# This should not be the current user in order to allow multiple replies
	# to the same message.
	def not_current_user(message)
		message.sender == current_user ? message.recipient : message.sender
	end

	def preview?
		params["commit"] == "Preview"
	end

end


