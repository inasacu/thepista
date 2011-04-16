class InstallationsController < ApplicationController
  before_filter :require_user

  before_filter   :get_venue,           :only => [:new, :index]
  before_filter   :get_installation,    :only => [:show, :edit, :update, :destroy]
  before_filter   :has_manager_access,  :only => [:edit, :update, :destroy]


  def index  
    store_location
    @installations = Installation.current_installations(@venue, params[:page])
  end

  def show
    # store_location    
    @venue = @installation.venue
    redirect_to :action => 'index', :id => @venue
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
    end

  end

  def create
    @installation = Installation.new(params[:installation])    
    unless current_user.is_manager_of?(@installation.venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    if @installation.save 
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @installation
    else
      render :action => 'new'
    end
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
    # @installation.played = false
    # @installation.save

    flash[:notice] = I18n.t(:successful_destroy)
    redirect_to :action => 'index'  
  end

  def set_reminder
    if @installation.update_attribute("reminder", !@installation.reminder)
      @installation.update_attribute("reminder", @installation.reminder)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_public
    if @installation.update_attribute("public", !@installation.public)
      @installation.update_attribute("public", @installation.public)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  private
  def has_manager_access
    unless current_user.is_manager_of?(@installation.venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_installation
    @installation = Installation.find(params[:id])
    unless current_user.is_manager_of?(@installation.venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_venue
    @venue = Venue.find(params[:id])
    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

end

