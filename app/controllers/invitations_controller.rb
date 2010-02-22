class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index  
    store_location     
    @user = current_user
    @invitations = Invitation.paginate(:all, 
        :conditions => ["user_id = ?", @user],:page => params[:page], :per_page => INVITATIONS_PER_PAGE, :order => "created_at desc")
    respond_to do |format|
      format.html 
    end 
  end
  
  def new
    @invitation = Invitation.new
    if (params[:group_id])
      @group = Group.find(params[:group_id])

    elsif (params[:schedule_id])
      @schedule = Schedule.find(params[:schedule_id])
      # @group = @schedule.group
    end

    respond_to do |format|
      format.html
    end
  end

  def create
    @user = current_user
    @invitation = Invitation.new(params[:invitation])
    @invitation.user = @user

    unless params[:schedule][:id].blank? 
      @schedule = Schedule.find(params[:schedule][:id])
      @invitation.item = @schedule
    end

    unless params[:group][:id].blank?
      @group = Group.find(params[:group][:id])
      @invitation.item = @group
    end

    if @invitation.save
      flash[:notice] = I18n.t(:invitation_successful_create)
    else
      redirect_to :action => 'new' and return
    end

    redirect_to invitations_url
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
  
      # verify user's email is not already a user on site nor has the user received a previous invitation
      @contacts.each do |contact|
        #if u = User.find(:first , :conditions => @users.email = '#{contact[1]}' , :include =>[:user])
        if user = User.find(:first , :conditions => ["email = ?", contact[1]] ) or 
              user = Invitation.find(:first , :conditions => ["email_addresses = ?", contact[1]] )
          @users << user
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
  end
  
  def invite_contact 
    if params[:emails]

      @contacts = []
      params[:emails].each do |email|
        @contacts << {:account => email}
      end

      @contacts.each do |contact|
        @contact_invitation = Invitation.new
        @contact_invitation.user = current_user
        @contact_invitation.email_addresses = contact[:account]
        @contact_invitation.message = I18n.t(:invitation_message)

        if @contact_invitation.save
          flash[:notice] = I18n.t(:invitation_successful_create)
        end
      end

    end
    
    redirect_to invitations_url
  end 
  
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    flash[:notice] = I18n.t(:invitation_deleted)
    redirect_to invitations_url
  end

end


