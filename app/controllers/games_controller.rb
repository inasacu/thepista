class GamesController < ApplicationController
  before_filter :require_user

  before_filter :get_game, :only => [:show, :edit, :update, :destroy, :set_score, :set_the_game_jornada]
  before_filter :get_cup, :only =>[:new, :index, :list]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy]

  def index
    @games = Game.group_stage_games(@cup, params[:page])
  end

  def list
    store_location
    @games = Game.group_round_games(@cup, params[:page])
    render :template => '/games/index'       
  end

  def show
    if @game.type_name == 'GroupStage'
      redirect_to :action => 'index', :id => @cup
      return
    else
      redirect_to :action => 'list', :id => @cup
      return
    end      
  end

  def new
    @game = Game.new

    unless current_user.is_manager_of?(@cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    if @cup
      # @home = @cup.the_escuadras
      # @away = @cup.the_escuadras
      
      the_last_game = @cup.games.last

      @game.cup_id = @cup.id      
      @game.starts_at = @cup.starts_at
      @game.ends_at = @cup.starts_at + (60 * 60 * 2)
      @game.reminder_at = @cup.starts_at - 2.day
      @game.type_name = 'GroupStage'
      @game.points_for_single = 0
      @game.points_for_double = 5
      @game.jornada = 1
    end

    # @previous_game = Game.find(:first, :conditions => ["id = (select max(id) from games where cup_id = ?) ", @cup.id])    
    @previous_game = @cup.games.last
    
    unless @previous_game.nil?
      @game.cup_id = @cup.id  
      @game.concept = @previous_game.concept      

      @game.starts_at = @previous_game.starts_at + 1.days
      @game.ends_at = @previous_game.ends_at + 1.days
      @game.reminder_at = @previous_game.starts_at - 1.day        

      @game.type_name = @previous_game.type_name      
      
      @game.points_for_single = @previous_game.points_for_single      
      @game.points_for_double = @previous_game.points_for_double      
      @game.points_for_draw = @previous_game.points_for_draw    
      @game.points_for_goal_difference = @previous_game.points_for_goal_difference    
      @game.points_for_goal_total = @previous_game.points_for_goal_total    
      @game.points_for_winner = @previous_game.points_for_winner         
       
      @game.jornada = @previous_game.jornada.to_i + 1
      @game.home_ranking = @previous_game.home_ranking
      @game.away_ranking = @previous_game.away_ranking
    end
  end

  def create
    @game = Game.new(params[:game]) 
         
    unless current_user.is_manager_of?(@game.cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_to cups_url
      return
    end

    if @game.save 
      flash[:notice] = I18n.t(:successful_create)
      redirect_to games_path(:id => @game.cup)
      return
    else
      render :action => 'new'
    end
  end

  def update
    if @game.update_attributes(params[:game]) 
      Standing.create_cup_escuadra_standing(@game.cup)
      flash[:success] = I18n.t(:successful_update)
      
      unless @game.all_group_stage_played(@game.cup)
        redirect_to games_path(:id => @game.cup)
      else
        redirect_to list_games_path(:id => @game.cup)
      end
      return
    else
      render :action => 'edit'
    end
  end

  def set_the_game_jornada
          
      unless current_user.is_manager_of?(@cup)
        flash[:warning] = I18n.t(:unauthorized)
        redirect_back_or_default('/index')
        return
      end
      
      jornada = params[:the_game][:jornada]
      if @game.update_attributes('jornada' => jornada)
        flash[:success] = I18n.t(:successful_update)
      end
      redirect_to games_path(:id => @cup)
      return
  end

  def destroy
    # @game.played = false
    # @game.save
    # @game.matches.each do |match|
    #   match.archive = false
    #   match.save!
    # end
    # Scorecard.delay.calculate_cup_scorecard(@game.cup)
    # @game.destroy
    # 
    # flash[:notice] = I18n.t(:successful_destroy)
    # redirect_to :action => 'index'  
  end

  private
  def has_manager_access
    unless current_user.is_manager_of?(@cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_game
    @game = Game.find(params[:id])
    @cup = @game.cup 
  end

  def get_cup
    @cup = Cup.find(params[:id])      
    unless @cup
      redirect_to(cups_url)
      return
    end
  end
end

