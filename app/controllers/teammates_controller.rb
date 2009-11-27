class TeammatesController < ApplicationController
  include UserHelper
   
  before_filter :require_user
  before_filter :setup_managers, :only => :create
  before_filter :setup_groups, :only => [:join_team, :leave_team]
  before_filter :setup_teammate, :only => [:join_team_accept, :join_team_decline]
    

  def index
    redirect_to   :controller => 'home', :action => 'index'
  end
  
  # methods
  def join_team 
    unless (current_user.is_manager_of?(@group) or !current_user.is_member_of?(@group))
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to :controller => 'groups', :action => 'show', :id => @group
      return
    end
    @role_user = RolesUsers.find_team_manager(@group)
    @manager = User.find(@role_user.user_id)
    @mate = User.find(params[:teammate])
    Teammate.create_teammate_join_team(@group, @mate, @manager)

    if @manager.teammate_notification?
      UserMailer.deliver_manager_join(
      :user => @mate,
      :friend => @manager,
      :group => @group,
      :email => @manager.email,
      :user_url => url_for(:controller => 'users', :action => 'show', :id => @mate),
      :group_url => url_for(:controller => 'groups', :action => 'show', :id => @group),
      :accept_url =>  url_for(:action => "accept",  :id => @mate),
      :decline_url => url_for(:action => "decline", :id => @mate),
      :teammate_accept_url =>  url_for(:action => "accept",  :id => @mate),
      :teammate_decline_url => url_for(:action => "decline", :id => @mate)
      )
    end
    
    flash[:notice] = I18n.t(:to_join_group_message_sent)
    # redirect_back_or_default('/index')
    redirect_to   :controller => 'home', :action => 'index'
    # end
  end 

  def leave_team
    # leaving is limited to the member
    unless current_user.is_member_of?(@group)
      flash[:notice] = I18n.t(:unauthorized)      
      # redirect_back_or_default('/index')
      redirect_to   :controller => 'home', :action => 'index'
      return
    end

    @leave_user = User.find(params[:teammate])   
    Teammate.create_teammate_leave_team(@group, @leave_user)

    if @leaveUser.teammate_notification?
      UserMailer.deliver_manager_leave(
        :user => current_user,
        :friend => @manager,
        :group => @group,
        :email => @manager.email,
        :user_url => url_for(:controller => 'users', :action => 'show', :id => @leaveUser),
        :group_url => url_for(:controller => 'groups', :action => 'show', :id => @group)
      )
    end

    flash[:notice] = I18n.t(:to_leave_group_message_sent)
    # redirect_back_or_default('/index')
    redirect_to   :controller => 'home', :action => 'index'
  end

  def join_team_accept    
    if @requester.requested_managers.include?(@approver)
      Teammate.create_teammate_details(@requester, @approver, @group)
      flash[:notice] = I18n.t(:petition_to_join_approved)
    end    
    redirect_back_or_default('/index')
  end
  
  def join_team_decline
    if @requester.requested_managers.include?(@approver)
      Teammate.breakup(@requester, @approver, @group)
      flash[:notice] = I18n.t(:petition_to_join_declined)
    end
      # redirect_back_or_default('/index')
      redirect_to   :controller => 'home', :action => 'index'
  end
  
  def destroy
    if @user.pending_managers.include?(@manager)
      Teammate.breakup(@user, @manager)
      flash[:notice] = I18n.t(:petition_to_join_declined)
    else
      flash[:notice] = I18n.t(:no_petition_to_join_group)
    end
      # redirect_back_or_default('/index')
      redirect_to   :controller => 'home', :action => 'index'
  end
  
  private  
  def setup_managers
    @user = current_user
    @manager = User.find(params[:id])
  end  
  
  def setup_groups
    @user = current_user
    @group = Group.find(params[:id])
  end
  
  def setup_teammate
    @teammate = Teammate.find(params[:id])
    @approver = User.find(@teammate.user_id)
    @requester = User.find(@teammate.manager_id)
    @group = Group.find(@teammate.group_id)    
  end
end