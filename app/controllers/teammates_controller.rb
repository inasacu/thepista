class TeammatesController < ApplicationController
  include UserHelper

  before_filter :require_user
  before_filter :setup_managers, :only => :create
  before_filter :setup_item, :only => [:join_item, :leave_item]  
  before_filter :setup_teammate_item, :only => [:join_item_accept, :join_item_decline]  
  before_filter :has_item_manager_access, :only => [:join_item, :join_item_accept]  
  before_filter :has_item_member_access, :only => [:leave_item]

  def index
    redirect_to root_url
  end

  def join_item
    @role_user = RolesUsers.find_item_manager(@item)
    @manager = User.find(@role_user.user_id)
    @mate = User.find(params[:teammate])
    Teammate.create_teammate_pre_join_item(@mate, @manager, @item, @sub_item)

    flash[:notice] = I18n.t(:to_join_item_message_sent)
    redirect_to petition_url
  end

  def leave_item
    @leave_user = User.find(params[:teammate])   
    Teammate.create_teammate_leave_item(@leave_user, @item, @sub_item)
    # Teammate.send_later(:create_teammate_leave_item, @leave_user, @item, @sub_item)

    flash[:notice] = I18n.t(:to_leave_item_message_sent)
    redirect_to petition_url
  end

  def join_item_accept
    if @requester.requested_managers.include?(@approver)
      Teammate.send_later(:create_teammate_join_item, @requester, @approver, @item, @sub_item)
      flash[:notice] = I18n.t(:petition_to_join_approved)
    end    
    redirect_to petition_url
  end

  def join_item_decline
    if @requester.requested_managers.include?(@approver)
      @teammate.breakup_item(@requester, @approver)
      flash[:notice] = I18n.t(:petition_to_join_declined)
    end
    redirect_to petition_url
  end

  private  
  def setup_managers
    @user = current_user
    @manager = User.find(params[:id])
  end  

  def setup_item
    @user = current_user

    @item = nil
    case params[:item]
    when "Challenge"
      @item = Challenge.find(params[:id])
    when "Group"
      @item = Group.find(params[:id])
    when "Cup"
      @item = Cup.find(params[:id])
    else
    end

    @sub_item = nil
    if params[:sub_item]
      case params[:sub_item]
      when "Challenge"
        @sub_item = Challenge.find(params[:sub_id])
      when "Group"
        @sub_item = Group.find(params[:sub_id])
      when "Cup"
        @sub_item = Cup.find(params[:sub_id])
      else
      end
    end

  end

  def setup_teammate_item
    @teammate = Teammate.find(params[:id])    
    @approver = User.find(@teammate.user_id)
    @requester = User.find(@teammate.manager_id)

    @item = nil    
    case @teammate.item.class.to_s
    when "Challenge"
      @item = Challenge.find(@teammate.item_id)
    when "Group"
      @item = Group.find(@teammate.item_id)
    when "Cup"
      @item = Cup.find(@teammate.item_id)
    else
      @item = Group.find(@teammate.group_id) unless @teammate.group_id.nil?
    end

    @sub_item = nil
    unless @teammate.sub_item_type == nil
      case @teammate.sub_item.class.to_s
      when "Group"
        @sub_item = Group.find(@teammate.sub_item_id)
      else
      end
    end
    
  end
  
  def has_item_manager_access
    unless current_user.is_manager_of?(@item) or !current_user.is_member_of?(@item)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to petition_url
      return
    end
  end

  def has_item_member_access
    unless current_user.is_member_of?(@item)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to petition_url
      return
    end
  end

end