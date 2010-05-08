class CupsController < ApplicationController
  before_filter :require_user    
  before_filter :get_cup, :only => [:team_list, :show, :edit, :update, :set_available, :set_enable_comments, :set_looking, :destroy]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy, :set_available, :set_enable_comments, :set_looking]
  
  before_filter :the_maximo, :only => [:new]

  def index
    @cups = Cup.paginate :page => params[:page], :order => 'name' 
  end

  # def list
  #   @cups = Cup.paginate(:all, :conditions => ["archive = false and id not in (?)", current_user.cups], 
  #   :page => params[:page], :order => 'name') unless current_user.cups.blank?
  #   @cups = Cup.paginate(:all, :conditions =>["archive = false"], 
  #   :page => params[:page], :order => 'name') if current_user.cups.blank?
  #   render :template => '/cups/index'       
  # end

  def squad_list
    @squads = @cup.squads.paginate(:page => params[:page], :per_page => USERS_PER_PAGE)
    @total = @cup.squads.count
  end

  def show
    store_location 
  end

  def new
    @cup = Cup.new
    @cup.time_zone = current_user.time_zone if !current_user.time_zone.nil?
    @sports = Sport.find(:all) 
  end

  def create
    @cup = Cup.new(params[:cup])		
    @user = current_user

    if @cup.save and @cup.create_cup_details(current_user)
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @cup
    else
      render :action => 'new'
    end
  end

  def update
    @original_cup = Cup.find(params[:id])
    
    if @cup.update_attributes(params[:cup]) 
      if (@original_cup.points_for_win != @cup.points_for_win) or 
        (@original_cup.points_for_lose != @cup.points_for_lose) or 
        (@original_cup.points_for_draw != @cup.points_for_draw)

        Scorecard.send_later(:calculate_cup_scorecard, @cup)    
      end

      flash[:notice] = I18n.t(:successful_update)
      redirect_to @cup
    else
      render :action => 'edit'
    end
  end 

  def set_looking
    if @cup.update_attribute("looking", !@cup.looking)
      @cup.update_attribute("looking", @cup.looking)  

      flash[:notice] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end   

  def set_available
    if @cup.update_attribute("available", !@cup.available)
      @cup.update_attribute("available", @cup.available)  

      flash[:notice] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_enable_comments
    if @cup.update_attribute("enable_comments", !@cup.enable_comments)
      @cup.update_attribute("enable_comments", @cup.enable_comments)  

      flash[:notice] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def destroy
    # @cup = Cup.find(params[:id])
    counter = 0
    @cup.schedules.each {|schedule| counter += 1 }

    # @cup.destroy unless counter > 0

    flash[:notice] = I18n.t(:successfully_destroyed)
    redirect_to cup_url
  end

  private
  def get_cup
    @cup = Cup.find(params[:id])
  end

  def has_manager_access
    unless current_user.is_manager_of?(@cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end 
  
  def the_maximo
    unless current_user.is_maximo? 
      redirect_to root_url
      return
    end
  end
  
end