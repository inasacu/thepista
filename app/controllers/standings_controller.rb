class StandingsController < ApplicationController
  before_filter :require_user
  
  def index
    @tournaments = current_user.tournaments.paginate(:page => params[:page])
  end
  
  def list
    @tournaments = Tournament.paginate(:all, :conditions => ["id not in (?)", current_user.tournaments], :per_page => 10, :page => params[:page])   
    @standings = Standing.find(:all, 
                               :conditions => ["round_id in (?) and standings.archive = true", current_user.tournaments])
    # @tournaments = Tournament.paginate(:all, :conditions => ["id in (?)", @standings], :per_page => 10, :page => params[:page])   
    render :template => '/standings/index' 
  end
  
  def show
    @tournament = Tournament.find(params[:id])
    @standings = Standing.users_round_standing(@tournament.rounds)
  end
  
  def show_archive
    @tournament = Tournament.find(params[:id])
    @standings = Standing.find(:all, 
                               :joins => "LEFT JOIN users on users.id = standings.user_id",
                               :conditions => ["tournament_id in (?) and user_id > 0 and played > 0 and standings.archive = true", @tournament, Time.zone.now],
                               :order => "tournament_id, points DESC, ranking, users.name")          
    @archive = true
    render :template => '/standings/show'
  end

  def archive
    @tournament = Tournament.find(params[:id])
    
    @standings = Standing.find(:all, :conditions => ["tournament_id = ?", @tournament.id])
    @standings.each do |standing|
      standing.archive = true
      standing.season_ends_at = Time.utc(Time.zone.now.year, 8, 1) # set end of season to 1 august current.year
      standing.save!
    end

    # tournament standings for previous season were archive so create new ones
    Standing.create_tournament_standing(@tournament)
    @tournament.users.each do |user|
      Standing.create_user_standing(user, @tournament)
    end
    redirect_to :action => 'index'
  end
end

