class InstallationsController < ApplicationController
  before_filter :require_user

  before_filter   :get_venue,           :only => [:new, :index]
  before_filter   :get_installation,    :only => [:show, :edit, :update]
  before_filter   :has_manager_access,  :only => [:edit, :update]

  def index  
    store_location
    @installations = Installation.current_installations(@venue, params[:page])
    render @the_template   
  end

  def show
    store_location    
    @timetables = Timetable.find(:all, :conditions => ["installation_id = ?", @installation])
    render @the_template   
  end

  def new
    @installation = Installation.new
    @markers = Marker.find(:all)
    @sports = Sport.find(:all)

    if @venue
      @installation.venue_id = @venue.id
      @installation.starts_at = @venue.starts_at
      @installation.ends_at = @venue.ends_at
      @installation.marker_id = @venue.marker_id
      @installation.public = @venue.public

      @previous_installation = Installation.find(:first, :conditions => ["venue_id = ? and archive = false", @venue.id], :order => "created_at DESC")

      unless @previous_installation.nil?
        @installation.name = @previous_installation.name
        @installation.starts_at = @previous_installation.starts_at
        @installation.ends_at = @previous_installation.ends_at
        @installation.description = @previous_installation.description        
        @installation.conditions = @previous_installation.conditions
        @installation.fee_per_pista = @previous_installation.fee_per_pista
        @installation.fee_per_lighting = @previous_installation.fee_per_lighting
        @installation.sport_id = @previous_installation.sport_id
        @installation.lighting = @previous_installation.lighting
        @installation.outdoor = @previous_installation.outdoor

        @installation.photo_file_name = @previous_installation.photo_file_name        
        @installation.photo_content_type = @previous_installation.photo_content_type        
        @installation.photo_file_size = @previous_installation.photo_file_size
        @installation.photo_updated_at = @previous_installation.photo_updated_at
      end

    end

    render @the_template   
  end

  def create
    @installation = Installation.new(params[:installation])  

    if @installation.save 
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @installation
    else
      render :action => 'new'
    end
  end

  def edit
    set_the_template('installations/new')
    render @the_template
  end

  def update
    if @installation.update_attributes(params[:installation])  
      flash[:success] = I18n.t(:successful_update)
      redirect_to @installation
    else
      render :action => 'edit'
    end
  end

  def destroy
    @installation = Installation.find(params[:id])
    @venue = @installation.venue

    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    @installation.destroy
    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to @venue
  end

  private
  def has_manager_access
    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_installation
    @installation = Installation.find(params[:id])
    @venue = @installation.venue
  end

  def get_venue
    @venue = Venue.find(params[:id])
  end

end