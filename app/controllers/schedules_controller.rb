class SchedulesController < ApplicationController
  before_filter :require_user
  
  before_filter :get_schedule, :only => [:show, :edit, :update, :destroy, :team_roster, :team_last_minute, :team_no_show, :team_unavailable]
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
  
  def show
    store_location
    @schedule = Schedule.find(params[:id])
    @group = @schedule.group
    @previous = Schedule.previous(@schedule)
    @next = Schedule.next(@schedule)
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
      @schedule.group_id = @group.id
      @schedule.sport_id = @group.sport_id
      @schedule.marker_id = @group.marker_id
      @schedule.time_zone = @group.time_zone
      @schedule.jornada = 1

      @lastSchedule = Schedule.find(:first, :conditions => ["id = (select max(id) from schedules where group_id = ?) ", @group.id])    
      if !@lastSchedule.nil?
        @schedule = @lastSchedule 
        @schedule.jornada ||= 0
        @schedule.jornada += 1
        @schedule.starts_at = @lastSchedule.starts_at + 7.days
        @schedule.ends_at = @lastSchedule.ends_at + 7.days
        @schedule.reminder = @lastSchedule.reminder
        @schedule.subscription_at = @lastSchedule.starts_at - 2.days
        @schedule.non_subscription_at = @lastSchedule.starts_at - 1.day
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

