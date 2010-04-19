class GamesController < ApplicationController
  before_filter :require_user
  
  before_filter :get_game, :only => [:show, :edit, :update, :destroy]
  before_filter :get_cup, :only =>[:new]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy, :set_public, :set_reminder]
  before_filter :has_member_access, :only => :show
  
  def index
    @games = Game.current_games(current_user, params[:page])
  end

  def list    
    @games = Game.previous_games(current_user, params[:page])
    render :template => '/games/index'       
  end
  
  def show
    store_location  
  end

  def new    
    # editing is limited to administrator or creator
      @game = Game.new
      
      unless current_user.is_manager_of?(@cup)
        flash[:warning] = I18n.t(:unauthorized)
        redirect_back_or_default('/index')
        return
      end
      
      @home = @cup.the_escuadras
      @away = @cup.the_escuadras
      
      @game.cup_id = @cup.id      
      @game.starts_at = @cup.starts_at
      @game.ends_at = @cup.starts_at + (60 * 60 * 2)
      @game.reminder_at = @cup.starts_at - 1.day

      @previous_game = Game.find(:first, :conditions => ["id = (select max(id) from games where cup_id = ?) ", @cup.id])    
      unless @previous_game.nil?
        @game.starts_at = @previous_game.starts_at + 1.days
        @game.ends_at = @previous_game.ends_at + 1.days
        @game.reminder_at = @previous_game.starts_at - 1.days
      end
  end

  def create
    @game = Game.new(params[:game])         
    unless current_user.is_manager_of?(@game.cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to cups_url
      return
    end
    
    if @game.save # and @game.create_game_details(current_user)
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @game
    else
      render :action => 'new'
    end
  end
  
  # set the end of season, 1 august current_year + 1
  def edit
    @game.season_ends_at = Time.utc(Time.zone.now.year + 1, 8, 1)
  end
  
  def update
    if @game.update_attributes(params[:game]) and @game.create_game_details(current_user, true)  
      flash[:notice] = I18n.t(:successful_update)
      redirect_to @game
    else
      render :action => 'edit'
    end
  end

  def destroy    
      @game.played = false
      @game.save
      @game.matches.each do |match|
        match.archive = false
        match.save!
      end
      Scorecard.send_later(:calculate_cup_scorecard, @game.cup)
      @game.destroy
      
      flash[:notice] = I18n.t(:successful_destroy)
      redirect_to :action => 'index'  
  end

  private
  def has_manager_access
    unless current_user.is_manager_of?(@cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
  
  def has_member_access
    unless current_user.is_member_of?(@game.cup) or @game.public
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
  
  def get_game      
    @game = Game.find(params[:id])
    @cup = @game.cup
    # @previous = Game.previous(@game)
    # @next = Game.next(@game)    
  end
  
  def get_match_type 
    store_location 
    unless current_user.is_member_of?(@game.cup) or @game.public 
      redirect_to :action => 'index'
      return
    end
    @match_type = Type.find(:all, :conditions => "id in (1, 2, 3, 4)", :order => "id")
  end
  
  def get_cup
      @cup = Cup.find(params[:id])
      
      unless @cup
        redirect to cups_url
        return
      end
  end
end

