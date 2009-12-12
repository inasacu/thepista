class TournamentsController < ApplicationController
  before_filter :require_user
  before_filter :get_tournament, :only => [:tour_list, :show, :edit, :update, :set_available, :set_enable_comments, :destroy]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy]
  
  def index
    @tournaments = current_user.tournaments.paginate :page => params[:page], :order => 'name'  
     
    if @tournaments.nil? or @tournaments.blank?
      redirect_to :action => 'list'
      return
    end
  end

  def list
    @tournaments = Tournament.paginate(:all, 
          :conditions => ["archive = false and id not in (?)", current_user.tournaments], :page => params[:page], :order => 'name') unless current_user.tournaments.blank?
    @tournaments = Tournament.paginate(:all, :conditions =>["archive = false"], 
          :page => params[:page], :order => 'name') if current_user.tournaments.blank?
    render :template => '/tournaments/index'       
  end

  def tour_list
    @users = @tournament.users.paginate(:page => params[:page], :per_page => USERS_PER_PAGE)
    @total = @tournament.users.count
  end

  def show
    store_location 
  end

  def new
    @tournament = Tournament.new
    @tournament.time_zone = current_user.time_zone if !current_user.time_zone.nil?
    @markers = Marker.find(:all)
    @sports = Sport.find(:all)
  end

  def create
    @tournament = Tournament.new(params[:tournament])		
    @user = current_user

    if @tournament.save and @tournament.create_tournament_details(current_user)
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @tournament
    else
      render :action => 'new'
    end
  end

  def edit
    @tournament = Tournament.find(params[:id])
  end

  def update
    @original_tournament = Tournament.find(params[:id])

    if @tournament.update_attributes(params[:tournament]) 
      if (@original_tournament.points_for_win != @tournament.points_for_win) or 
        (@original_tournament.points_for_lose != @tournament.points_for_lose) or 
        (@original_tournament.points_for_draw != @tournament.points_for_draw)

        Scorecard.calculate_tournament_scorecard(@tournament)  
        # flash[:notice] = I18n.t(:successful_update)    
      end

      flash[:notice] = I18n.t(:successful_update)
      redirect_to @tournament
    else
      render :action => 'edit'
    end
  end    

  def set_available
    if @tournament.update_attribute("available", !@tournament.available)
      @tournament.update_attribute("available", @tournament.available)  

      flash[:notice] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_enable_comments
    if @tournament.update_attribute("enable_comments", !@tournament.enable_comments)
      @tournament.update_attribute("enable_comments", @tournament.enable_comments)  

      flash[:notice] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def destroy
    # @tournament = Tournament.find(params[:id])
    counter = 0
    @tournament.schedules.each {|schedule| counter += 1 }

    # @tournament.destroy unless counter > 0

    flash[:notice] = I18n.t(:successfully_destroyed)
    redirect_to tournament_url
  end

  private
  def get_tournament
    @tournament = Tournament.find(params[:id])    
    # redirect_to @tournament, :status => 301 if @tournament.has_better_id?
  end
  
  def has_manager_access
    unless current_user.is_manager_of?(@tournament)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
end