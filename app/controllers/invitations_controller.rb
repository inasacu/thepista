class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index       
    @user = current_user
    @invitations = Invitation.paginate(:all, :conditions => ["user_id = ?", @user],:page => params[:page], :per_page => INVITATIONS_PER_PAGE)
    respond_to do |format|
      format.html 
    end 
  end


  def invite_friends
    @user = current_user
  end

  def import
    @users = User.find(params[:id])
    begin
      @sites = {"gmail"  => Contacts::Gmail, "yahoo" => Contacts::Yahoo, "hotmail" => Contacts::Hotmail}
      @contacts = @sites[params[:from]].new(params[:login], params[:password]).contacts
      @users , @no_users = [], []
      @contacts.each do |contact|
        #if u = User.find(:first , :conditions => @users.email = '#{contact[1]}' , :include =>[:user])
        if u = User.find(:first , :conditions => "email = '#{contact[1]}'" )
          @users << u
        else
          @no_users << {:name => contact[0] , :email => contact[1]}
        end
      end
      respond_to do |format|
        format.html {render :template => 'shared/_contact_list', :layout => false}
        format.xml {render :xml => @contacts.to_xml}
      end
    end
  end







# 
# 
# 
#   def show
#     @invitation = Invitation.find(params[:id])
#   end
# 
#   def new
#     @invitation = Invitation.new
#     if (params[:group_id])
#       @group = Group.find(params[:group_id])
# 
#     elsif (params[:schedule_id])
#       @schedule = Schedule.find(params[:schedule_id])
#       @group = @schedule.group
#     end
# 
#     respond_to do |format|
#       format.html
#     end
#   end
# 
#   def create
#     @user = current_user
# 
#     @invitation = Invitation.new(params[:invitation])
#     @invitation.user = @user
#     
#     respond_to do |format|
#       if @invitation.save
#                 
#         # if params[:schedule][:id].blank?
#         #   @schedule = Schedule.find(params[:schedule][:id]) 
#         # elsif params[:group][:id].blank?
#         #   @group = Group.find(params[:group][:id])
#         # end
#         # 
#         #  recipient_messages(@message, @recipients) 
#         # 
#         #   if @schedule 
#         #     deliver_message_schedule(@message, @schedule, @recipients) 
#         #   elsif @group
#         #     deliver_invitation_group(@message, @schedule, @recipients)
#         #   end        
#         
#         flash[:notice] = I18n.t(:invitation_successfully_created)
#         format.html {
#           unless params[:welcome]
#             redirect_to user_path(@invitation.user)
#           else
#             redirect_to welcome_complete_user_path(@invitation.user)
#           end
#         }
#       else
#         format.html { render :action => "new" }
#       end
#     end
#   end
# 
# 
#   # def deliver_message_schedule(message, schedule, recipients)
#   #   recipients.each do |recipient|
#   #     if recipient.message_notification?
#   #       UserMailer.deliver_message_schedule(
#   #         :user => message.sender,
#   #         :email => recipient.email,
#   #         :message => message,
#   #         :schedule => schedule, :group => schedule.group, :receiver => recipient,
#   #         :user_url => url_for(:controller => 'users', :action => 'show', :id => current_user.id),
#   #         :reply_url => url_for(:controller => 'messages', :action => 'reply', :id => message.id),
#   #         :schedule_url => url_for(:controller => 'schedules', :action => 'show', :id => schedule.id),
#   #         :group_url => url_for(:controller => 'groups', :action => 'show', :id => schedule.group.id)
#   #       )
#   #     end
#   #   end
#   # end
#   
#   def import
#     @invitation = Invitation.new
#     @user = current_user   
#   end
#     
#   
#   def contact
#     @user = current_user 
#     @contacts = Contacts::Gmail.new(params[:login], params[:password]).contacts
#   end
#   
#   def invitecontact 
#     recipients = ""
#     if params[:contact_ids]
#        params[:contact_ids].each do |contact|
#           recipients += ", " if recipients.length > 0
#           recipients += contact
#        end
#     end
#     
#     if recipients.length > 0
#       @invitation = Invitation.new
#       @invitation.user_id = params[:user][:id]
#       @invitation.recipients = recipients
#       send_recipients
#     end
#   end 
#   
#   def send_recipients
#     if  @invitation.save      
#       @invitation.recipients.gsub(",", " ").split(" ").each do |recipient|
# #        @counter =+ 1
#         recipient.strip!
#         if recipient =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
#           InvitationMailer.deliver_invitation(
#             :email => recipient,
#             :invitation => @invitation,
#             :user => current_user
#           )
#         end
#       end
#       
#       flash[:notice] = "#{:your_sent_invitation.l}:  #{@invitation.recipients}"
#       render :partial => 'sent_invite', :locals => {:recipients => @invitation.recipients}
#       return
#     else
# #      redirect_to :action => 'new'
#       render :template =>  '/layouts/current/new'
#     end    
#   end
#   
#   def destroy
#     @invitation = Invitation.find(params[:id])
#     @invitation.destroy
#     flash[:notice] = I18n.t(:successful_destroy)
#     redirect_to invitations_url
#   end
end


