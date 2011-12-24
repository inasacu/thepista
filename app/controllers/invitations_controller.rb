class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index  
    redirect_to :action => 'invite'
  end
  
  def new
    @invitation = Invitation.new
    
    if (params[:group_id])
      @group = Group.find(params[:group_id])
    elsif (params[:schedule_id])
      @schedule = Schedule.find(params[:schedule_id])
    elsif (params[:challenge_id])
      @challenge = Challenge.find(params[:challenge_id])
    elsif (params[:cup_id])
      @cup = Cup.find(params[:cup_id])
    end
    
    respond_to do |format|
      format.html
    end
	render @the_template   
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

    unless params[:challenge][:id].blank?
      @challenge = Challenge.find(params[:challenge][:id])
      @invitation.item = @challenge
    end
    
    unless params[:cup][:id].blank?
      @cup = Cup.find(params[:cup][:id])
      @invitation.item = @cup
    end
    
    email_addresses = @invitation.email_addresses || ''
    
    text = "#{text.to_s.strip[0..12]}..." if text.to_s.length > 14
    
    @invitation.email_addresses = @invitation.email_addresses.to_s.strip[0..254] if @invitation.email_addresses.to_s.length > 254

    if @invitation.save     
      
      # email_addresses = @invitation.email_addresses || ''
      emails = email_addresses.gsub(",", " ").split(" ").collect{|email| email.strip }.uniq
      emails.each{ |email|
        @the_invitation = Invitation.new
        @the_invitation.message = @invitation.message
        @the_invitation.item = @invitation.item
        @the_invitation.user = @invitation.user
        @the_invitation.email_addresses = email
        @the_invitation.save!
      }  
      @invitation.destroy  
    
      flash[:notice] = I18n.t(:invitation_successful_create)
    else
      redirect_to :action => 'new' and return
    end

    redirect_to invitations_url
  end
  
  def invite
	render @the_template   
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
        if (user = User.contact_emails(contact[1]) or user = Invitation.contact_emails(contact[1]))              
          @users << user
        else
          @no_users << {:name => contact[0].nil? ? Invitation.email_to_name(contact[1]) : contact[0].capitalize , :email => contact[1]}
        end
      end
      return true
      
    rescue Contacts::AuthenticationError
      flash[:notice] = I18n.t(:username_password_donot_match)
      redirect_to :action => 'invite'

    end
	render @the_template   
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


