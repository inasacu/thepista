class MeetsController < ApplicationController
  before_filter :require_user
  
  before_filter :get_meet, :only => [:show, :edit, :update, :destroy, :set_public, :team_roster, :team_last_minute, :team_no_show, :team_unavailable]
  before_filter :get_round, :only =>[:new]
  before_filter :get_clash_type, :only => [:team_roster, :team_last_minute, :team_no_show, :team_unavailable]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy, :set_public]
  before_filter :has_member_access, :only => :show
  before_filter :excess_players, :only => [:show, :team_roster, :team_last_minute, :team_no_show, :team_unavailable]
  
  def index
    @meets = Meet.current_meets(current_user, params[:page])
  end

  def list    
    @meets = Meet.previous_meets(current_user, params[:page])
    render :template => '/meets/index'       
  end
  
  def show
    store_location
    @meet = Meet.find(params[:id])
    @round = @meet.round
    @previous = Meet.previous(@meet)
    @next = Meet.next(@meet)
  end

  def new    
    # editing is limited to administrator or creator
      @meet = Meet.new
      
      if @round        
        @tournament = @round.tournament
        @meet.round_id = @round.id
        @meet.sport_id = @tournament.sport_id
        @meet.marker_id = @tournament.marker_id
        @meet.time_zone = @tournament.time_zone
        @meet.starts_at = @tournament.starts_at 
        @meet.reminder_at = @tournament.starts_at        
      end
      
      unless @meet.round.nil?
        @tournament = @meet.round.tournament 
        @meet.sport_id = @tournament.sport_id
        @meet.marker_id = @tournament.marker_id
        @meet.time_zone = @tournament.time_zone
        @meet.starts_at = @tournament.starts_at 
        @meet.reminder_at = @tournament.starts_at      
      end
    
      @meet.jornada = 1
      @previous_meet = Meet.find(:first, :conditions => ["id = (select max(id) from meets where round_id = ?) ", @round.id])    
      unless @previous_meet.nil?
        @meet.jornada = @previous_meet.jornada + 1
        @meet.player_limit = @previous_meet.player_limit
        @meet.public = @previous_meet.public
        @meet.starts_at = @previous_meet.starts_at + 7.days
        @meet.ends_at = @previous_meet.ends_at + 7.days
        @meet.reminder_at = @previous_meet.reminder_at + 7.days
      end
  end

  def create
    @meet = Meet.new(params[:meet])   
    @tournament = @meet.round.tournament 
    
    unless current_user.is_tour_manager_of?(@tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    if @meet.save and @meet.create_meet_details(current_user)
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @meet
    else
      render :action => 'new'
    end
  end
  
  # set the end of season, 1 august current_year + 1
  def edit
    # @meet.season_ends_at = Time.utc(Time.zone.now.year + 1, 8, 1)
  end
  
  def update
    if @meet.update_attributes(params[:meet]) and @meet.create_meet_details(current_user, true)  
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @meet
    else
      render :action => 'edit'
    end
  end

  def destroy    
      @meet.played = false
      @meet.save
      @meet.clashes.each do |clash|
        clash.archive = false
        clash.save!
      end
      Standing.calculate_round_scorecard(@meet.round)
      @meet.destroy
      
      flash[:notice] = I18n.t(:successful_destroy)
      redirect_to :action => 'index'  
  end
  
  def set_previous_profile
    @meet = Meet.find(params[:id])  
    @tournament = @meet.round.tournament 
    
    unless current_user.is_tour_manager_of?(@tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    @previous_meet = Meet.find(:first, 
    :conditions => ["id = (select max(id) from meets where round_id = ? and id < ?) ", @meet.round.id, @meet.id])    
    unless @previous_meet.nil?

      @meet.clashes.each do |clash|
        @previous_clash = Match.find(:first, :conditions => ["meet_id = ? and user_id = ?", @previous_meet.id, clash.user_id])
        clash.technical = @previous_clash.technical
        clash.physical = @previous_clash.physical
        clash.save!
      end

      flash[:notice] = I18n.t(:successful_update)
    end
    redirect_back_or_default('/index')
  end
  
  def set_roster_technical
      @clash = Match.find(params[:id])
      @tournament = @clash.meet.round.tournament

      unless current_user.is_tour_manager_of?(@tournament)
        flash[:warning] = I18n.t(:unauthorized)
        redirect_back_or_default('/index')
        return
      end
      
      technical = params[:roster][:technical]
      if @clash.update_attributes('technical' => technical)
        flash[:notice] = I18n.t(:successful_update)
      end
      redirect_back_or_default('/index')
  end

  def set_roster_physical
    @clash = Match.find(params[:id])
    @tournament = @clash.meet.round.tournament

    unless current_user.is_tour_manager_of?(@tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    physical = params[:roster][:physical]
    if @clash.update_attributes('physical' => physical)
      flash[:notice] = I18n.t(:successful_update)
    end
    redirect_back_or_default('/index')
  end

  def set_roster_position_name
    @clash = Match.find(params[:id])
    @tournament = @clash.meet.round.tournament

    unless current_user.is_tour_manager_of?(@tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
    @type = Type.find(params[:roster][:position_name])
    if @clash.update_attributes('position_id' => @type.id)
      flash[:notice] = I18n.t(:successful_update)
    end
    redirect_back_or_default('/index')
  end

  def set_public
    if @meet.update_attribute("public", !@meet.public)
      @meet.update_attribute("public", @meet.public)  

      flash[:notice] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end
  
  private
  def has_manager_access
    unless current_user.is_tour_manager_of?(@meet.round.tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
  
  def has_member_access
    unless current_user.is_tour_member_of?(@meet.round.tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
  
  def get_meet
    @meet = Meet.find(params[:id])
    @round = @meet.round    
  end
  
  def get_clash_type 
    store_location 
    unless current_user.is_tour_member_of?(@meet.round.tournament)  
      redirect_to :action => 'index'
      return
    end
    @clash_type = Type.find(:all, :conditions => "id in (1, 2, 3, 4)", :order => "id")
  end
  
  def get_round
    @round = Round.find(params[:id])
  end
  
  def excess_players
    unless @meet.convocados.empty? or @meet.player_limit == 0
      flash[:warning] = I18n.t(:meet_excess_player) if (@meet.convocados.count > @meet.player_limit)  
    end
  end
end