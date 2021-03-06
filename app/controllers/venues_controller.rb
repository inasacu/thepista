class VenuesController < ApplicationController
  before_filter :require_user    
  before_filter :get_venue, :only => [:show, :edit, :update]
  before_filter :has_manager_access, :only => [:edit, :update]

  def index
    @venues = Venue.where("archive = false").page(params[:page]).order('venues.name').includes(:installations)
    render @the_template
  end

  def show
    store_location 
    render @the_template
  end

  def new
    @venue = Venue.new
    @venue.starts_at = Time.zone.now.change(:hour => 8, :min => 0, :sec => 0)
    @venue.ends_at  = Time.zone.now.change(:hour => 23, :min => 0, :sec => 0)
    @venue.time_zone = current_user.time_zone if !current_user.time_zone.nil?
    render @the_template
  end

  def create
    @venue = Venue.new(params[:venue])		
    @user = current_user

    if @venue.save and @venue.create_venue_details(current_user)
      successful_create
      redirect_to @venue
    else
      render :action => 'new'
    end
  end

  def edit
    set_the_template('venues/new')
    render @the_template
  end

  def update
    if @venue.update_attributes(params[:venue]) 
      controller_successful_update
      redirect_to @venue
    else
      render :action => 'edit'
    end
  end 

  private
  def get_venue
    @venue = Venue.find(params[:id])
  end

  def has_manager_access
    unless is_current_manager_of(@venue)
      warning_unauthorized
      redirect_back_or_default('/index')
      return
    end
  end
end