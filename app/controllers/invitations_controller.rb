class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index  
    store_location     
    @user = current_user
    @invitations = Invitation.paginate(:all, :conditions => ["user_id = ?", @user],:page => params[:page], :per_page => INVITATIONS_PER_PAGE)
    respond_to do |format|
      format.html 
    end 
  end
  
  def invite
  end
  
  def contact
    begin
      @users = current_user
      @sites = {"gmail"  => Contacts::Gmail, "yahoo" => Contacts::Yahoo, "hotmail" => Contacts::Hotmail}
      @contacts = @sites[params[:from]].new(params[:login], params[:password]).contacts

      if @contacts.nil? or @contacts.blank?
        flash[:notice] = I18n.t(:username_password_donot_match)
        redirect_to :action => 'invite'
        return
      end
      
      @users , @no_users = [], []
      @contacts.each do |contact|
        #if u = User.find(:first , :conditions => @users.email = '#{contact[1]}' , :include =>[:user])
        if u = User.find(:first , :conditions => ["email = ?", contact[1]] )
          @users << u
        else
          @no_users << {:name => contact[0] , :email => contact[1]}
        end
      end
      return true
      
    rescue Contacts::AuthenticationError
      flash[:notice] = I18n.t(:username_password_donot_match)
      redirect_to :action => 'invite'
      
      # return false
    # rescue Exception => exc
    #   logger.error("Message for the log file #{exc.message}")
    #   # flash[:notice] = "Store error message"
    #   # redirect_to(:action => 'index')
    #     flash[:notice] = I18n.t(:username_password_donot_match)
    #     redirect_to :action => 'invite'

    end


    # respond_to do |format|
    #   format.html {render :template => 'invitations/_contact_list', :layout => false}
    #   format.xml {render :xml => @contacts.to_xml}
    # end
  end
  
  def invite_contact 
    recipients = ""
    if params[:emails]


      # params[:emails].each do |contact|
      #   recipients += "#{contact}, "      
      # end
      # recipients.chop.chop

      # if recipients.length > 0
      # params[:emails].each do |contact|
      #   @invitation = Invitation.new
      #   @invitation.user = current_user
      #   @invitation.email_addresses = contact
      #   @invitation.message = "sending contact information..."
      #   if @invitation.save
      #     # send message
      #     flash[:notice] = I18n.t(:invitation_successfully_created)
      #   end
      # end

      @contacts = []
      params[:emails].each do |email|
         @contacts << {:accy => email}
       end

      @contacts.each do |contact|
      @contact_invitation = Invitation.new
      @contact_invitation.user = current_user
      @contact_invitation.email_addresses = contact[:acct]
      @contact_invitation.message = contact[:acct]
      # @contact_invitation.save!

      # respond_to do |format|
        if @contact_invitation.save
          # send invitation
          flash[:notice] = I18n.t(:invitation_successfully_created)
        end
      end

    end

    redirect_back_or_default('/index')
  end 
  

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

end


