class GroupsController < ApplicationController
  before_filter :require_user    
  before_filter :get_group, :only => [:team_list, :show, :edit, :update, :set_available, :set_enable_comments, :set_looking, :destroy]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy, :set_available, :set_enable_comments, :set_looking]

  def index
    @groups = Group.paginate(:all, :conditions => ["archive = false and id in (?)", current_user.groups], 
    :page => params[:page], :order => 'name') unless current_user.groups.blank?

    if @groups.nil? or @groups.blank?
      redirect_to :action => 'list'
      return
    end
  end

  def list
    @groups = Group.paginate(:all, :conditions => ["archive = false and id not in (?)", current_user.groups], 
    :page => params[:page], :order => 'name') unless current_user.groups.blank?
    @groups = Group.paginate(:all, :conditions =>["archive = false"], 
    :page => params[:page], :order => 'name') if current_user.groups.blank?
    render :template => '/groups/index'       
  end

  def team_list
    @users = @group.users.paginate(:page => params[:page], :per_page => USERS_PER_PAGE)
    @total = @group.users.count
  end

  def show
    store_location 
    # @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
    @group.time_zone = current_user.time_zone if !current_user.time_zone.nil?
    @markers = Marker.find(:all)
    @sports = Sport.find(:all)
  end

  def create
    @group = Group.new(params[:group])		
    @user = current_user

    if @group.save and @group.create_group_details(current_user)
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @group
    else
      render :action => 'new'
    end
  end

  def edit
    # @group = Group.find(params[:id])
  end

  def update
    @original_group = Group.find(params[:id])

    if @group.update_attributes(params[:group]) 
      if (@original_group.points_for_win != @group.points_for_win) or 
        (@original_group.points_for_lose != @group.points_for_lose) or 
        (@original_group.points_for_draw != @group.points_for_draw)

        Scorecard.delay.calculate_group_scorecard(@group)    
      end

      flash[:success] = I18n.t(:successful_update)
      redirect_to @group
    else
      render :action => 'edit'
    end
  end 

  def set_looking
    if @group.update_attribute("looking", !@group.looking)
      @group.update_attribute("looking", @group.looking)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end   

  def set_available
    if @group.update_attribute("available", !@group.available)
      @group.update_attribute("available", @group.available)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_enable_comments
    if @group.update_attribute("enable_comments", !@group.enable_comments)
      @group.update_attribute("enable_comments", @group.enable_comments)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def destroy
    # @group = Group.find(params[:id])
    counter = 0
    @group.schedules.each {|schedule| counter += 1 }

    # @group.destroy unless counter > 0

    flash[:notice] = I18n.t(:successfully_destroyed)
    redirect_to group_url
  end

  private
  def get_group
    @group = Group.find(params[:id])
  end

  def has_manager_access
    unless current_user.is_manager_of?(@group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
end