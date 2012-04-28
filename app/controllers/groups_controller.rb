class GroupsController < ApplicationController
  before_filter :require_user    
  before_filter :get_group, :only => [:team_list, :show, :edit, :update, :set_automatic_petition,  :destroy]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy, :set_automatic_petition]

  def index
		@groups = Group.where("groups.archive = false").page(params[:page]).order('groups.created_at DESC')
    render @the_template
  end

  def list
    redirect_to :action => 'index'
      return      
  end

  def team_list
    @users = @group.users.page(params[:page])
    @total = @group.users.count
    render @the_template
  end

  def show
    store_location 
    render @the_template
  end

  def new    
    marker = Marker.find(params[:marker_id]) if params[:marker_id]    
    @group = Group.new
    @group.marker = marker
    @sports = Sport.find(:all)
    render @the_template
  end

  def create
    @group = Group.new(params[:group])	
    @group.name_to_second_team
    @group.name_to_description
    @group.default_conditions
    @group.sport_to_points_player_limit
    @group.time_zone = current_user.time_zone if !current_user.time_zone.nil?
    
    @user = current_user

    if @group.save and @group.create_group_details(current_user)
      successful_create
      redirect_to @group
    else
      render :action => 'new'
    end
  end
  
	def edit
		set_the_template('groups/new')
		render @the_template   
	end

  def update
    @original_group = Group.find(params[:id])

    if @group.update_attributes(params[:group]) 
      if (@original_group.points_for_win != @group.points_for_win) or 
        (@original_group.points_for_lose != @group.points_for_lose) or 
        (@original_group.points_for_draw != @group.points_for_draw)

        Scorecard.delay.calculate_group_scorecard(@group)    
      end

      controller_successful_update
      redirect_to @group
    else
      render :action => 'edit'
    end
  end 
  
  def set_automatic_petition
    if @group.update_attribute("automatic_petition", !@group.automatic_petition)
      @group.update_attribute("automatic_petition", @group.automatic_petition)  

      controller_successful_update
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  # def destroy
  #   # @group = Group.find(params[:id])
  #   counter = 0
  #   @group.schedules.each {|schedule| counter += 1 }
  # 
  #   # @group.destroy unless counter > 0
  # 
  #   
  #   redirect_to group_url
  # end

  private
  def get_group
    @group = Group.find(params[:id])
  end

  def has_manager_access
    unless is_current_manager_of(@group)
      warning_unauthorized
      redirect_back_or_default('/index')
      return
    end
  end
end