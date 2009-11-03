class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index       
    @user = current_user
    @invitations = Invitation.paginate(:all, :conditions => ["user_id = ?", @user],:page => params[:page], :per_page => INVITATIONS_PER_PAGE)
    respond_to do |format|
      format.html 
    end 
  end


  # def invite_friends
  #   @user = current_user
  # end
  # 
  # def import
  #   @users = User.find(params[:id])
  #   begin
  #     @sites = {"gmail"  => Contacts::Gmail, "yahoo" => Contacts::Yahoo, "hotmail" => Contacts::Hotmail}
  #     @contacts = @sites[params[:from]].new(params[:login], params[:password]).contacts
  #     @users , @no_users = [], []
  #     @contacts.each do |contact|
  #       #if u = User.find(:first , :conditions => @users.email = '#{contact[1]}' , :include =>[:user])
  #       if u = User.find(:first , :conditions => "email = '#{contact[1]}'" )
  #         @users << u
  #       else
  #         @no_users << {:name => contact[0] , :email => contact[1]}
  #       end
  #     end
  #     respond_to do |format|
  #       format.html {render :template => 'shared/_contact_list', :layout => false}
  #       format.xml {render :xml => @contacts.to_xml}
  #     end
  #   end
  # end


  def new
    @invitation = Invitation.new
    if (params[:group_id])
      @group = Group.find(params[:group_id])

    elsif (params[:schedule_id])
      @schedule = Schedule.find(params[:schedule_id])
      @group = @schedule.group
    end

    respond_to do |format|
      format.html
    end
  end

  def create
    @user = current_user

    @invitation = Invitation.new(params[:invitation])
    @invitation.user = @user
    
    respond_to do |format|
      if @invitation.save
        
        flash[:notice] = I18n.t(:invitation_successfully_created)
        format.html {
          unless params[:welcome]
            redirect_to user_path(@invitation.user)
          else
            redirect_to welcome_complete_user_path(@invitation.user)
          end
        }
      else
        format.html { render :action => "new" }
      end
    end
  end
  
  def import
    @invitation = Invitation.new
    @user = current_user   
  end    
  
  def contact
    @user = current_user 
    @contacts = Contacts::Gmail.new(params[:login], params[:password]).contacts
  end
  
  def invite_contact 
    recipients = ""
    if params[:contact_ids]
       params[:contact_ids].each do |contact|
          recipients += ", " if recipients.length > 0
          recipients += contact
       end
    end
    
    if recipients.length > 0
      @invitation = Invitation.new
      @invitation.user_id = params[:user][:id]
      @invitation.recipients = recipients
      send_recipients
    end
  end 
  
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


