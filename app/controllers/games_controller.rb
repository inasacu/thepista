class GamesController < ApplicationController
  before_filter :require_user

  before_filter :get_game, :only => [:edit, :update, :destroy, :set_score]
  before_filter :get_cup, :only =>[:new, :index, :list]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy]

  def index
    @games = Game.group_stage_games(@cup, params[:page])
  end

  def list    
    @games = Game.group_round_games(@cup, params[:page])
    render :template => '/games/index'       
  end

  def show
    store_location  
  end

  def new    
    @game = Game.new

    unless current_user.is_manager_of?(@cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    if @cup
      @home = @cup.the_escuadras
      @away = @cup.the_escuadras

      @game.cup_id = @cup.id      
      @game.starts_at = @cup.starts_at
      @game.ends_at = @cup.starts_at + (60 * 60 * 2)
      @game.reminder_at = @cup.starts_at - 1.day
      @game.type_name = 'GroupStage'
      @game.points_for_single = 0
      @game.points_for_double = 5
      @game.jornada = 1
    end

    @previous_game = Game.find(:first, :conditions => ["id = (select max(id) from games where cup_id = ?) ", @cup.id])    
    unless @previous_game.nil?
      @game.cup_id = @cup.id  
      @game.concept = @previous_game.concept      

      @game.starts_at = @previous_game.starts_at + 1.days
      @game.ends_at = @previous_game.ends_at + 1.days
      @game.reminder_at = @previous_game.starts_at - 1.day        

      @game.type_name = @previous_game.type_name      
      @game.points_for_single = @previous_game.points_for_single      
      @game.points_for_double = @previous_game.points_for_double      
      @game.jornada = @previous_game.jornada.to_i + 1

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

  def edit
    if @cup
      @home = @cup.the_escuadras
      @away = @cup.the_escuadras
    end
  end

  def update
    if @game.update_attributes(params[:game]) 
      flash[:notice] = I18n.t(:successful_update)
      redirect_to games_path(:id => @game.cup)
      return
    else
      render :action => 'edit'
    end
  end

  def set_score
  end

  def destroy    
    # @game.played = false
    # @game.save
    # @game.matches.each do |match|
    #   match.archive = false
    #   match.save!
    # end
    # Scorecard.send_later(:calculate_cup_scorecard, @game.cup)
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
      redirect to cups_url
      return
    end
  end
end

