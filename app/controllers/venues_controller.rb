class VenuesController < ApplicationController
  before_filter :require_user    
  before_filter :get_venue, :only => [:venue_list, :show, :edit, :update, :set_available, :set_enable_comments, :set_looking, :destroy]
  before_filter :has_manager_access, :only => [:edit, :update, :destroy, :set_available, :set_enable_comments, :set_looking]

  def index
    @venues = Venue.paginate(:all, :conditions => ["archive = false"], :page => params[:page], :order => 'name') 
  end

  def show
    store_location 
  end

  def new
    @venue = Venue.new
    @venue.time_zone = current_user.time_zone if !current_user.time_zone.nil?
  end

  def create
    @venue = Venue.new(params[:venue])		
    @user = current_user

    if @venue.save and @venue.create_venue_details(current_user)
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @venue
    else
      render :action => 'new'
    end
  end

  def edit
    # @venue = Venue.find(params[:id])
  end

  def update
    @original_group = Venue.find(params[:id])

    if @venue.update_attributes(params[:group]) 
      if (@original_group.points_for_win != @venue.points_for_win) or 
        (@original_group.points_for_lose != @venue.points_for_lose) or 
        (@original_group.points_for_draw != @venue.points_for_draw)

        Scorecard.send_later(:calculate_group_scorecard, @venue)    
      end

      flash[:success] = I18n.t(:successful_update)
      redirect_to @venue
    else
      render :action => 'edit'
    end
  end 

  def set_available
    if @venue.update_attribute("available", !@venue.available)
      @venue.update_attribute("available", @venue.available)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_enable_comments
    if @venue.update_attribute("enable_comments", !@venue.enable_comments)
      @venue.update_attribute("enable_comments", @venue.enable_comments)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def destroy
    # @venue = Venue.find(params[:id])
    counter = 0
    @venue.schedules.each {|schedule| counter += 1 }

    # @venue.destroy unless counter > 0

    flash[:notice] = I18n.t(:successfully_destroyed)
    redirect_to group_url
  end

  private
  def get_venue
    @venue = Venue.find(params[:id])
  end

  def has_manager_access
    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
end