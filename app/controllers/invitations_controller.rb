class InvitationsController < ApplicationController
  before_filter :require_user
  
  def index  
    redirect_to :action => 'new'
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

    render @the_template  
  end
  
  def create
    @user = current_user
    @invitation = Invitation.new(params[:invitation])
    @invitation.user = @user

    unless params[:schedule].nil? || params[:schedule][:id].blank? 
      @schedule = Schedule.find(params[:schedule][:id])
      @invitation.item = @schedule
    end

    unless params[:group].nil? || params[:group][:id].blank?
      @group = Group.find(params[:group][:id])
      @invitation.item = @group
    end

    unless params[:challenge].nil? || params[:challenge][:id].blank?
      @challenge = Challenge.find(params[:challenge][:id])
      @invitation.item = @challenge
    end
    
    unless params[:cup].nil? || params[:cup][:id].blank?
      @cup = Cup.find(params[:cup][:id])
      @invitation.item = @cup
    end
    
    email_addresses = @invitation.email_addresses || ''
    
    text = "#{text.to_s.strip[0..12]}..." if text.to_s.length > 14
    
    @invitation.email_addresses = @invitation.email_addresses.to_s.strip[0..254] if @invitation.email_addresses.to_s.length > 254

    #if @invitation.save     
          
      # email_addresses = @invitation.email_addresses || ''
      emails = email_addresses.gsub(",", " ").split(" ").collect{|email| email.strip }.uniq
      emails.each{ |email|
        @the_invitation = Invitation.new
        @the_invitation.message = @invitation.message
        @the_invitation.item = @invitation.item
        @the_invitation.user = @invitation.user
        @the_invitation.email_addresses = email
        
        @the_invitation.is_from_widget = WidgetHelper.is_widget_form(params[:form_type])
        if !session[:current_branch].nil?
          @the_invitation.widget_host = session[:current_branch_real_url]
        end    
           
        @the_invitation.save!
      }  
      # @invitation.destroy  
    
      flash[:notice] = I18n.t(:invitation_successful_create)
    #end
    
    if WidgetHelper.is_widget_form(params[:form_type])
		  redirect_to "/widget/event/#{@schedule.id}/invitation"
		  return
		end
		
    redirect_to :action => 'new' 

    # end
    # redirect_to invitations_url
  end  

end


