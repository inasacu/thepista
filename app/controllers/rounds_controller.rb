class RoundsController < ApplicationController
  before_filter :require_user
  before_filter :get_round, :only => [:tour_list, :show, :edit, :update, :set_available, :set_enable_comments, :destroy]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy]
  before_filter :get_tournament, :only =>[:new]

  def index
    tournament = current_user.tournaments.first
    @rounds = tournament.rounds.paginate :page => params[:page], :order => 'name'      
  end

  def list
    @rounds = Round.paginate(:all, 
    :conditions => ["archive = false and id not in (?)", current_user.rounds], :page => params[:page], :order => 'name') unless current_user.rounds.blank?
    @rounds = Round.paginate(:all, :conditions =>["archive = false"], 
    :page => params[:page], :order => 'name') if current_user.rounds.blank?
    render :template => '/rounds/index'       
  end

  def tour_list
    @users = @round.users.paginate(:page => params[:page], :per_page => USERS_PER_PAGE)
    @total = @round.users.count
  end

  def show
    @tournament = @round.tournament    
    redirect_to tournament_url(@tournament)
    return
  end

  def new    
    # editing is limited to administrator or creator
      @round = Round.new
            
      if @tournament
        @round.tournament_id = @tournament.id
      end
    
      @round.phase = 1
      @previous_round = Round.find(:first, :conditions => ["id = (select max(id) from rounds where tournament_id = ?) ", @tournament.id])    
      unless @previous_round.nil?
        @round.phase = @previous_round.phase + 1
      end
  end

  def create
    @round = Round.new(params[:round])		
    @user = current_user

    if @round.save 
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @round
    else
      render :action => 'new'
    end
  end

  def edit
    @round = Round.find(params[:id])
    @tournament = @round.tournament
  end

  def update
    if @round.update_attributes(params[:round])
      flash[:notice] = I18n.t(:successful_update)
      @tournament = @round.tournament    
      redirect_to tournament_url(@tournament)
      return
    else
      render :action => 'edit'
    end
  end   

  # def destroy
  #   # @round = Round.find(params[:id])
  #   counter = 0
  #   @round.rounds.each {|round| counter += 1 }
  # 
  #   # @round.destroy unless counter > 0
  # 
  #   flash[:notice] = I18n.t(:successfully_destroyed)
  #   redirect_to round_url
  # end

  private
  def get_round
    @round = Round.find(params[:id])    
    # redirect_to @round, :status => 301 if @round.has_better_id?
  end

  def has_manager_access
    unless current_user.is_manager_of?(@round.tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
  
  def get_tournament
    # depended on number of tournaments for current user 
    # a tournament id is needed
    if current_user.tournaments.count == 0
      redirect_to :controller => 'tournaments', :action => 'new' 
      return

    elsif current_user.tournaments.count == 1 
      @tournament = current_user.tournaments.find(:first)

    elsif current_user.tournaments.count > 1 and !params[:id].nil?
      @tournament = Tournament.find(params[:id])

    elsif current_user.tournaments.count > 1 and params[:id].nil? 
      redirect_to :controller => 'tournaments', :action => 'index' 
      return
    end
    
  end
  
  def excess_players
    unless @round.convocados.empty? or @round.player_limit == 0
      flash[:warning] = I18n.t(:round_excess_player) if (@round.convocados.count > @round.player_limit)  
    end
  end
end

