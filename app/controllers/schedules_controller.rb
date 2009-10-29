class SchedulesController < ApplicationController
  before_filter :require_user
  
  before_filter :get_schedule, :only => [:show, :edit, :update, :destroy, :set_public, :team_roster, :team_last_minute, :team_no_show, :team_unavailable]
  before_filter :get_group, :only =>[:new]
  before_filter :get_match_type, :only => [:team_roster, :team_last_minute, :team_no_show, :team_unavailable]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy]
  before_filter :has_member_access, :only => :show
  before_filter :excess_players, :only => [:show, :team_roster, :team_last_minute, :team_no_show, :team_unavailable]
  
  def index
    @schedules = Schedule.current_schedules(current_user, params[:page])
  end

  def list    
    @schedules = Schedule.previous_schedules(current_user, params[:page])
    render :template => '/schedules/index'       
  end
  
  def archive_list 
    @schedules = Schedule.archive_schedules(current_user, params[:page])
    render :template => '/schedules/index'       
  end
  
  def show
    store_location
    @schedule = Schedule.find(params[:id])
    @group = @schedule.group
    @previous = Schedule.previous(@schedule)
    @next = Schedule.next(@schedule)
    
    unless current_user.is_member_of?(@schedule.group) 
      redirect_back_or_default('/index')
    end
  end
  
  # def search
  #   count = Schedule.count_by_solr(params[:search])
  #   @schedules = Schedule.paginate_all_by_solr(params[:search], :page => params[:page], :total_entries => count, :limit => 25, :offset => 1)
  # 
  #   # @schedules = Schedule.paginate_all_by_solr(params[:search].to_s, :page => params[:page])
  #   render :template => '/schedules/index'
  # end

  def new    
    # editing is limited to administrator or creator
      @schedule = Schedule.new
      
      if @group
        @schedule.group_id = @group.id
        @schedule.sport_id = @group.sport_id
        @schedule.marker_id = @group.marker_id
        @schedule.time_zone = @group.time_zone
      end
    
      @schedule.jornada = 1
      @schedule.season = Time.zone.now.year
      @schedule.season_ends_at = Time.utc(Time.zone.now.year + 1, 8, 1)

      @previous_schedule = Schedule.find(:first, :conditions => ["id = (select max(id) from schedules where group_id = ?) ", @group.id])    
      unless @previous_schedule.nil?
        @schedule.jornada = @previous_schedule.jornada + 1
        @schedule.season = @previous_schedule.season
        @schedule.fee_per_game = @previous_schedule.fee_per_game
        @schedule.fee_per_pista = @previous_schedule.fee_per_pista
        @schedule.player_limit = @previous_schedule.player_limit
        @schedule.public = @previous_schedule.public
        @schedule.starts_at = @previous_schedule.starts_at + 7.days
        @schedule.ends_at = @previous_schedule.ends_at + 7.days
        
        @schedule.subscription_at = @previous_schedule.starts_at + 7.days
        @schedule.non_subscription_at = @previous_schedule.starts_at + 7.days        
        @schedule.reminder = @previous_schedule.starts_at + 5.days
      end
  end

  def create
    @schedule = Schedule.new(params[:schedule])    
    unless current_user.is_manager_of?(@schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    if @schedule.save and @schedule.create_schedule_details(current_user)
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @schedule
    else
      render :action => 'new'
    end
  end
  
  # set the end of season, 1 august current_year + 1
  def edit
    @schedule.season_ends_at = Time.utc(Time.zone.now.year + 1, 8, 1)
  end
  
  def update
    if @schedule.update_attributes(params[:schedule]) and @schedule.create_schedule_details(current_user, true)    
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @schedule
    else
      render :action => 'edit'
    end
  end

  def destroy    
      @schedule.played = false
      @schedule.save
      @schedule.matches.each do |match|
        match.archive = false
        match.save!
      end
      Scorecard.calculate_group_scorecard(@schedule.group)
      @schedule.destroy
      
      flash[:notice] = I18n.t(:successful_destroy)
      redirect_to :action => 'index'  
  end
  
  def set_roster_technical
      @match = Match.find(params[:id])
      
      unless current_user.is_manager_of?(@match.schedule.group)
        flash[:warning] = I18n.t(:unauthorized)
        redirect_back_or_default('/index')
        return
      end
      
      technical = params[:roster][:technical]
      if @match.update_attributes('technical' => technical)
        flash[:notice] = I18n.t(:successful_update)
      end
      redirect_back_or_default('/index')
  end

  def set_roster_physical
    @match = Match.find(params[:id])

    unless current_user.is_manager_of?(@match.schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    technical = params[:roster][:physical]
    if @match.update_attributes('physical' => physical)
      flash[:notice] = I18n.t(:successful_update)
    end
    redirect_back_or_default('/index')
  end

  def set_roster_position_name
    @match = Match.find(params[:id])
    unless current_user.is_manager_of?(@match.schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    @type = Type.find(params[:roster][:position_name])
    if @match.update_attributes('position_id' => @type.id)
      flash[:notice] = I18n.t(:successful_update)
    end
    redirect_back_or_default('/index')
  end

  def set_public
    if @schedule.update_attribute("public", !@schedule.public)
      @schedule.update_attribute("public", @schedule.public)  

      flash[:notice] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end
  
  private
  def has_manager_access
    unless current_user.is_manager_of?(@schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
  
  def has_member_access
    unless current_user.is_member_of?(@schedule.group)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
  
  def get_schedule
    @schedule = Schedule.find(params[:id])
    @group = @schedule.group
  end
  
  def get_match_type 
    store_location 
    unless current_user.is_member_of?(@schedule.group)  
      redirect_to :action => 'index'
      return
    end
    @match_type = Type.find(:all, :conditions => "id in (1, 2, 3, 4)", :order => "id")
  end
  
  def get_group
    # depended on number of groups for current user 
    # a group id is needed
    if current_user.groups.count == 0
      redirect_to :controller => 'groups', :action => 'new' 
      return

    elsif current_user.groups.count == 1 
      @group = current_user.groups.find(:first)

    elsif current_user.groups.count > 1 and !params[:id].nil?
      @group = Group.find(params[:id])

    elsif current_user.groups.count > 1 and params[:id].nil? 
      redirect_to :controller => 'groups', :action => 'index' 
      return
    end
    
  end
  
  def excess_players
    unless @schedule.convocados.empty? or @schedule.player_limit == 0
      flash[:warning] = I18n.t(:schedule_excess_player) if (@schedule.convocados.count > @schedule.player_limit)  
    end
  end
end

