class TeammatesController < ApplicationController
  include UserHelper
  
  before_filter :login_required
  before_filter :setup_managers, :only => :create
  before_filter :setup_groups, :only => [:join, :leave, :join_team, :leave_team]
  before_filter :setup_teammate, :only => [:accept, :decline]
    
  # Send a team request.
  # We'd rather call this "request", but that's not allowed by Rails.
  def create
    Teammate.request(current_user, @manager)

    if @manager.message_notification?
      UserMailer.deliver_manager_request(
      :user => current_user,
      :manager => @manager,
      :user_url => url_for(:controller => 'users', :action => 'show', :id => current_user),
      :accept_url =>  url_for(:action => "accept",  :id => current_user),
      :decline_url => url_for(:action => "decline", :id => current_user)
      )
    end
    flash[:notice] = "#{t :join_group_message }"
    redirect_to :controller => 'users', :action => 'show', :id => @manager
  end
    
  def join_team 
    # manage join allows manager of group to join others
    permit "manager of :group", :group => @group do  
      @role_user = RolesUsers.find_team_manager(@group)
      @manager = User.find(@role_user.user_id)
      @mate = User.find(params[:teammate])
      Teammate.join(@mate, @manager, @group)
      @teammate = Teammate.find_by_user_id_and_group_id(@mate, @group)

      if @manager.message_notification?
        UserMailer.deliver_manager_join(
        :user => @mate,
        :friend => @manager,
        :group => @group,
        :email => @manager.email,
        :user_url => url_for(:controller => 'users', :action => 'show', :id => @mate),
        :group_url => url_for(:controller => 'groups', :action => 'show', :id => @group),
        :accept_url =>  url_for(:action => "accept",  :id => @mate),
        :decline_url => url_for(:action => "decline", :id => @mate),
        :teammate_accept_url =>  url_for(:action => "accept",  :id => @teammate.id),
        :teammate_decline_url => url_for(:action => "decline", :id => @teammate.id)
        )
      end

      flash[:notice] = "#{t(:to_join_group_message) } #{@group.name} #{t :has_been_sent }."
      redirect_to :controller => 'groups', :action => 'show', :id => @group
    end
  end 
    
  def join 
    # joining is limited to the non member
    permit "not member of :group or not manager of :group or not creator of :group", :group => @group do  
      @role_user = RolesUsers.find_team_manager(@group)
      @manager = User.find(@role_user.user_id)
      Teammate.join(current_user, @manager, @group)
      @teammate = Teammate.find_by_user_id_and_group_id(current_user, @group)

      if @manager.message_notification?
        UserMailer.deliver_manager_join(
        :user => current_user,
        :friend => @manager,
        :group => @group,
        :email => @manager.email,
        :user_url => url_for(:controller => 'users', :action => 'show', :id => current_user),
        :group_url => url_for(:controller => 'groups', :action => 'show', :id => @group),
        :accept_url =>  url_for(:action => "accept",  :id => current_user),
        :decline_url => url_for(:action => "decline", :id => current_user),
        :teammate_accept_url =>  url_for(:action => "accept",  :id => @teammate.id),
        :teammate_decline_url => url_for(:action => "decline", :id => @teammate.id)
        )
      end
      flash[:notice] = "#{t(:to_join_group_message) } #{@group.name} #{t(:has_been_sent_female) }."
      redirect_to :controller => 'groups', :action => 'show', :id => @group
    end
  end 

  def accept    
    if @requester.requested_managers.include?(@approver)
      Teammate.accept(@requester, @approver, @group)
      
      GroupsUsers.join_team(@approver, @group) 
      GroupsUsers.join_team(@requester, @group) 
      Scorecard.create_user_scorecard(@approver, @group)
      Scorecard.create_user_scorecard(@requester, @group)
      
      @group.accepts_role 'member', @approver
      @group.schedules.each do |schedule|
        schedule.create_matches_for_join_user(@approver)
        schedule.create_user_fees
      end

      Scorecard.set_archive_flag(@approver, @group, false)
      Match.set_archive_flag(@approver, @group, false)
      Scorecard.set_user_group_scorecard(@approver, @group)
      
      flash[:notice] = "#{t :approved_petition_to_join } #{@group.name}!"
    end
    redirect_to :controller => 'groups', :action => 'show', :id => @group
  end
  
  def decline
    if @requester.requested_managers.include?(@approver)
      Teammate.breakup(@requester, @approver, @group)
      flash[:notice] = "#{t :cancel_petition_to_join } #{@group.name}"
    end
    redirect_to :controller => 'groups', :action => 'show', :id => @group
  end
  
  def leave_team
    # leaving is limited to the member    
    if current_user.is_manager_of?(@group)
      @leaveUser = User.find(params[:teammate])
      @role_user = RolesUsers.find_team_manager(@group)
      @manager = User.find(@role_user.user_id) 
      
      GroupsUsers.leave_team(@leaveUser, @group)
      Teammate.breakup(@leaveUser, @manager, @group)
      @group.accepts_no_role 'member', @leaveUser
      
      Scorecard.set_archive_flag(@leaveUser, @group, true)
      Match.set_archive_flag(@leaveUser, @group, true)
      
      if @leaveUser.message_notification?
        UserMailer.deliver_manager_leave(
          :user => current_user,
          :friend => @manager,
          :group => @group,
          :email => @manager.email,
          :user_url => url_for(:controller => 'users', :action => 'show', :id => @leaveUser),
          :group_url => url_for(:controller => 'groups', :action => 'show', :id => @group)
        )
      end
      flash[:notice] = "#{t :to_leave_group_message } #{@group.name} #{t(:has_been_sent_female) }."
      redirect_to :controller => 'users', :action => 'show', :id => @leaveUser    
    end      
  end
  
  def leave
    # leaving is limited to the member
    permit "member of :group", :group => @group do    
      @role_user = RolesUsers.find_team_manager(@group)
      @manager = User.find(@role_user.user_id) 

      GroupsUsers.leave_team(@user, @group)
      Teammate.breakup(@user, @manager, @group)
      @group.accepts_no_role 'member', @user

      Scorecard.set_archive_flag(@user, @group, true)
      Match.set_archive_flag(@user, @group, true)

      if @manager.message_notification?
        UserMailer.deliver_manager_leave(
        :user => current_user,
        :friend => @manager,
        :group => @group,
        :email => @manager.email,
        :user_url => url_for(:controller => 'users', :action => 'show', :id => current_user),
        :group_url => url_for(:controller => 'groups', :action => 'show', :id => @group)
        )
      end
      flash[:notice] = "#{t :to_leave_group_message } #{@group.name} #{t(:has_been_sent_female) }."
      redirect_to :controller => 'users', :action => 'show', :id => @user    
    end      
  end
  
  def destroy
    if @user.pending_managers.include?(@manager)
      Teammate.breakup(@user, @manager)
      flash[:notice] = "#{t :cancel_petition_to_join }"
    else
      flash[:notice] = "#{t :no_petition_to_join_group } #{@manager.name}!"
    end
    redirect_to :controller => 'groups', :action => 'show', :id => @group
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