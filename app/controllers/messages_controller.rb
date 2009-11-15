class MessagesController < ApplicationController
  before_filter :require_user

  
  # GET /messages
  def index
    store_location
    @messages = current_user.received_messages(params[:page])
    respond_to do |format|
      format.html 
    end
  end


  # GET /messages/1/edit
  def edit
    @message = current_message
  end
 
  # GET /messages/sent
  def sent
    store_location
    @messages = current_user.sent_messages(params[:page])
    respond_to do |format|
      format.html { render :template => "messages/index" }
    end
  end
  
  # GET /messages/trash
  def trash
    @messages = current_user.trashed_messages(params[:page])
    respond_to do |format|
      format.html { render :template => "messages/index" }
    end
  end
 
  def show
    store_location
    
    @message = Message.find(:first, :conditions => ["id = (select parent_id from messages where id =?)", params[:id]])    
    @messages = current_user.find_message_in_conversation(@message)
    @messages.each { |message| message.mark_as_read if current_user == message.recipient }        
    @recipients = current_user.find_user_in_conversation(@message, false)      
    
    @all_messages =  @message.conversation.messages 
          
    respond_to do |format|
      format.html
    end
  end
 
  def new
    # TODO - need to have some relationship to any of these to be able to send message:
    #        user, goup, schedule
    
    @message = Message.new
    
    if (params[:id])
        @recipient = User.find(params[:id])

    elsif (params[:recipient_id])
      @recipients = User.find(params[:recipient_id])
      
    elsif (params[:group_id])
      @group = Group.find(params[:group_id])
      @recipients = User.find_group_mates(@group)

    elsif (params[:schedule_id])
      @schedule = Schedule.find(params[:schedule_id])
      @group = @schedule.group

    elsif (params[:match_id])
      @match = Match.find(params[:match_id])
      @schedule = @match.schedule
      @group = @schedule.group

    elsif (params[:scorecard_id])
        @scorecard = Schedule.find(params[:scorecard_id])
        @group = @scorecard.group
        @recipients = User.find_group_mates(@group)
    else
      @recipients = User.find_all_by_mates(current_user)
    end

    respond_to do |format|
      format.html
    end
  end
 
  def reply_message    
    @message = Message.new(params[:message])
        
    all_parent = Message.find(:all, :conditions => ["parent_id = ?", params[:message][:parent_id]])    
    reply_message = all_parent.first
    @recipients = current_user.find_user_in_conversation(params[:message][:parent_id])    
    first_in_conversation = true
        
     unless @recipients.nil?
        @recipients.each do |recipient| 

          @recipient_message = Message.new      
          @recipient_message.body = @message.body
          @recipient_message.subject = reply_message.subject
          @recipient_message.sender = current_user
          @recipient_message.recipient = recipient
          
          if first_in_conversation
            @recipient_message.parent_id = params[:message][:parent_id]       
            @recipient_message.conversation_id = reply_message.conversation_id 
            @recipient_message.save!
            first_in_conversation = false
          else            
            if @recipient_message.save               
              @recipient_message.update_attribute('parent_id', params[:message][:parent_id]) 
            end
          end

        end

        all_parent.each do |message| 
            if message.untrash(message.other_user(current_user))
              flash[:notice] = I18n.t(:recycled_message)
            end
        end
        
        flash[:notice] = I18n.t(:message_sent)
      end
       redirect_back_or_default('/index') 
    
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
        # @match.schedule.create_schedule_details(current_user, true)
        group_messages(@message, @recipients, @match.schedule)

      elsif @schedule 
        # @schedule.create_schedule_details(current_user, true)
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

  # rescue Exception => e
  #   flash[:error] = e.message
  #   redirect_to :action => 'new', :id => @recipient.id and return if @recipient
  #   redirect_to :action => 'new'  and return     

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
  
  # def deliver_message_schedule(message, schedule, recipients)
  #   recipients.each do |recipient|
  # 
  #     if recipient.message_notification?
  #       UserMailer.deliver_message_schedule(
  #         :user => message.sender,
  #         :email => recipient.email,
  #         :message => message,
  #         :schedule => schedule, :group => schedule.group, :receiver => recipient,
  #         :user_url => url_for(:controller => 'users', :action => 'show', :id => current_user.id),
  #         :reply_url => url_for(:controller => 'messages', :action => 'reply', :id => message.id),
  #         :schedule_url => url_for(:controller => 'schedules', :action => 'show', :id => schedule.id),
  #         :group_url => url_for(:controller => 'groups', :action => 'show', :id => schedule.group.id)
  #       )
  #     end
  #   end
  # end
  
  # def deliver_message_match(message, schedule, recipients)
  #   recipients.each do |recipient|
  # 
  #     if recipient.message_notification?
  #       UserMailer.deliver_message_match(
  #       :user => current_user,
  #       :email => recipient.email,
  #       :message => message,
  #       :schedule => schedule, :group => schedule.group,
  #       :user_url => url_for(:controller => 'users', :action => 'show', :id => current_user.id),
  #       :reply_url => url_for(:controller => 'messages', :action => 'reply', :id => message.id),
  #       :schedule_url => url_for(:controller => 'schedules', :action => 'show', :id => schedule.id),
  #       :group_url => url_for(:controller => 'groups', :action => 'show', :id => schedule.group.id)
  #       )
  #     end
  #   end
  # end
  
  def deliver_message_scorecard(message, scorecards, recipients, group)  
    recipients.each do |recipient|

      if recipient.message_notification?
        UserMailer.deliver_message_scorecard(
        :user => current_user,
        :email => recipient.email,
        :message => message, :receiver => recipient, :scorecards => scorecards, :group => group,
        :user_url => url_for(:controller => 'users', :action => 'show', :id => current_user.id),
        :reply_url => url_for(:controller => 'messages', :action => 'reply', :id => message.id),
        :group_url => url_for(:controller => 'groups', :action => 'show', :id => group.id),
        :scorecard_url => url_for(:controller => 'scorecards', :action => 'show', :id => group.id)
        )     
      end
    end 
  end
  
  def destroy
    @message = Message.find_all_parent_messages(params[:id])
    # @message = Message.find(:all, :conditions => ["parent_id = (select parent_id from messages where id = ?)", params[:id]])

    @message.each do |message| 
      if message.trash(current_user)
        flash[:notice] = I18n.t(:recycled_message)
      else
        # This should never happen...
        flash[:error] = I18n.t(:invalid_action)
      end
    end
    respond_to do |format|
      format.html { 
        redirect_to messages_url }
      end

    end

    def undestroy
      @message = Message.find_all_parent_messages(params[:id])
      # @message = Message.find(:all, :conditions => ["parent_id = (select parent_id from messages where id = ?)", params[:id]])

      @message.each do |message| 
        if message.untrash(current_user)
          flash[:notice] = I18n.t(:recycled_message)
        else
          # This should never happen...
          flash[:error] = I18n.t(:invalid_action)
        end
      end
      respond_to do |format|
        format.html { 
          redirect_to messages_url }
        end

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


