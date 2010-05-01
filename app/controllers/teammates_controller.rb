class TeammatesController < ApplicationController
  include UserHelper

  before_filter :require_user
  
  before_filter :setup_managers, :only => :create
  before_filter :setup_group, :only => [:join_team, :leave_team]  
  before_filter :setup_teammate, :only => [:join_team_accept, :join_team_decline]  
  before_filter :has_manager_access, :only => [:join_team]  
  before_filter :has_member_access, :only => [:leave_team]
  
  before_filter :setup_item, :only => [:join_item, :leave_item]  
  before_filter :setup_teammate_item, :only => [:join_item_accept, :join_item_decline]  
  before_filter :has_item_manager_access, :only => [:join_item]  
  before_filter :has_item_member_access, :only => [:leave_item]

  def index
    redirect_to root_url
  end

  # methods
  def join_team
    @role_user = RolesUsers.find_team_manager(@group)
    @manager = User.find(@role_user.user_id)
    @mate = User.find(params[:teammate])
    Teammate.create_teammate_join_team(@group, @mate, @manager)

    flash[:notice] = I18n.t(:to_join_item_message_sent)
    redirect_to root_url
  end 

  def leave_team
    @leave_user = User.find(params[:teammate])   
    Teammate.create_teammate_leave_team(@group, @leave_user)

    flash[:notice] = I18n.t(:to_leave_item_message_sent)
    redirect_to root_url
  end

  def join_item
    @role_user = RolesUsers.find_item_manager(@item)
    @manager = User.find(@role_user.user_id)
    @mate = User.find(params[:teammate])
    Teammate.create_teammate_join_item(@mate, @manager, @item)

    flash[:notice] = I18n.t(:to_join_item_message_sent)
    redirect_to root_url
  end

  def leave_item
    @leave_user = User.find(params[:teammate])   
    Teammate.create_teammate_leave_item(@leave_user, @item)

    flash[:notice] = I18n.t(:to_leave_item_message_sent)
    redirect_to root_url
  end

  def join_team_accept
    if @requester.requested_managers.include?(@approver)
      # Teammate.create_teammate_details(@requester, @approver, @group)
      Teammate.send_later(:create_teammate_details, @requester, @approver, @group)
      flash[:notice] = I18n.t(:petition_to_join_approved)
    end    
    redirect_to root_url
  end

  def join_team_decline
    if @requester.requested_managers.include?(@approver)
      Teammate.breakup(@requester, @approver, @group)
      flash[:notice] = I18n.t(:petition_to_join_declined)
    end
    redirect_to root_url
  end

  def join_item_accept
    if @requester.requested_managers.include?(@approver)
      Teammate.send_later(:create_teammate_item_details, @requester, @approver, @item)
      flash[:notice] = I18n.t(:petition_to_join_approved)
    end    
    redirect_to root_url
  end

  def join_item_decline
    if @requester.requested_managers.include?(@approver)
      # Teammate.breakup_item(@requester, @approver, @item)
      Teammate.create_teammate_leave_item(@requester, @approver, @item)
      flash[:notice] = I18n.t(:petition_to_join_declined)
    end
    redirect_to root_url
  end

  def destroy
    if @user.pending_managers.include?(@manager)
      Teammate.breakup(@user, @manager)
      flash[:notice] = I18n.t(:petition_to_join_declined)
    else
      flash[:notice] = I18n.t(:no_petition_to_join_group)
    end
    redirect_to root_url
  end

  private  
  def setup_managers
    @user = current_user
    @manager = User.find(params[:id])
  end  

  def setup_group
    @user = current_user
    @group = Group.find(params[:id])
  end 

  def setup_item
    @user = current_user
    
    case params[:item]
    when "Challenge"
      @item = Challenge.find(params[:id])
    when "Group"
      @item = Group.find(params[:id])
    else
    end
    
  end

  def setup_teammate
    @teammate = Teammate.find(params[:id])    
    @approver = User.find(@teammate.user_id)
    @requester = User.find(@teammate.manager_id)
    @group = Group.find(@teammate.group_id)    
  end

  def setup_teammate_item
    @teammate = Teammate.find(params[:id])    
    @approver = User.find(@teammate.user_id)
    @requester = User.find(@teammate.manager_id)
    
    case @teammate.item.class.to_s
    when "Challenge"
      @item = Challenge.find(@teammate.item_id)
    when "Group"
      @item = Group.find(@teammate.item_id)
    else
    end
       
  end

  def has_manager_access
    unless current_user.is_manager_of?(@group) or !current_user.is_member_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end

  def has_member_access
    unless current_user.is_member_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end

  def has_item_manager_access
    unless current_user.is_manager_of?(@item) or !current_user.is_member_of?(@item)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end

  def has_item_member_access
    unless current_user.is_member_of?(@item)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to root_url
      return
    end
  end

end