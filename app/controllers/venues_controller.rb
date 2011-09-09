class VenuesController < ApplicationController
  before_filter :require_user    
  before_filter :get_venue, :only => [:show, :edit, :update]
  before_filter :has_manager_access, :only => [:edit, :update]
  
  def index
    @venues = Venue.paginate(:all, :conditions => ["archive = false"], :page => params[:page], :order => 'name') 
  end

  def show
    store_location 
  end

  def new
    @venue = Venue.new
    @venue.starts_at = Time.zone.now.change(:hour => 8, :min => 0, :sec => 0)
    @venue.ends_at  = Time.zone.now.change(:hour => 23, :min => 0, :sec => 0)
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
  end

  def update
    if @venue.update_attributes(params[:venue]) 
      flash[:success] = I18n.t(:successful_update)
      redirect_to @venue
    else
      render :action => 'edit'
    end
  end 

  private
  def get_venue
    @venue = Venue.find(params[:id])
    @group = []
    @venue.marker.groups.each {|group| @group = group}
  end

  def has_manager_access
    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end
end