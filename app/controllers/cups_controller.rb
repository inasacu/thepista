class CupsController < ApplicationController
  before_filter :require_user    
  before_filter :get_cup, :only => [:team_list, :show, :edit, :update, :destroy]
  before_filter :get_current_cup, :only => [:index, :list]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy]

  def index
    if @has_no_cups
      redirect_to :action => 'list'
      return
    end 
    render @the_template
  end

  def list    
    @cups = Cup.previous_cups(params[:page])
    set_the_template('cups/index')
    render @the_template    
  end

  def squad_list
    @squads = @cup.squads.page(params[:page])
    @total = @cup.squads.count 
    render @the_template
  end

  def show
    store_location  
    render @the_template
  end

  def new
    @cup = Cup.new
    @cup.time_zone = current_user.time_zone if !current_user.time_zone.nil?
    @cup.deadline_at = (Time.now + 7.days).midnight 
    @cup.starts_at = (@cup.deadline_at + 1.day) + 19.hours
    @cup.ends_at = (@cup.deadline_at + 60.day) + 21.hours
    @sports = Sport.find(:all)  
    render @the_template
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

  def edit
    set_the_template('cups/new')
    render @the_template
  end

  def update
    @original_cup = Cup.find(params[:id])

    if @cup.update_attributes(params[:cup]) 
      if (@original_cup.points_for_win != @cup.points_for_win) or 
        (@original_cup.points_for_lose != @cup.points_for_lose) or 
        (@original_cup.points_for_draw != @cup.points_for_draw)

        Scorecard.delay.calculate_cup_scorecard(@cup)    
      end

      flash[:success] = I18n.t(:successful_update)
      redirect_to @cup
    else
      render :action => 'edit'
    end
  end 

  def destroy
    counter = 0
    @cup.games.each {|game| counter += 1 }
    @cup.destroy unless counter > 0

    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to cups_url
  end

  private
  def get_cup
    @cup = Cup.find(params[:id])
  end

  def get_current_cup
    @cups = Cup.current_cups(params[:page])
    @has_no_cups = (@cups.nil? or @cups.blank?)
  end

  def has_manager_access
    unless current_user.is_manager_of?(@cup)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end 

end