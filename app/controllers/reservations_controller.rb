require 'active_support'  # needs rubygems
    
class ReservationsController < ApplicationController
  before_filter :require_user

  before_filter   :get_installation,    :only => [:new, :index]
  before_filter   :get_venue,           :only => [:list]
  before_filter   :get_reservation,     :only => [:show, :edit, :update, :destroy]
  before_filter   :has_manager_access,  :only => [:edit, :update, :destroy]


  def index  
    store_location

    my_offset = 3600 * +2  # MADRID

    # find the zone with that offset
    zone_name = ActiveSupport::TimeZone::MAPPING.keys.find do |name|
      ActiveSupport::TimeZone[name].utc_offset == my_offset
    end
    zone = ActiveSupport::TimeZone[zone_name]

    @time_locally = Time.now
    @time_in_zone = zone.at(@time_locally)

    # p time_locally.rfc822   # => "Fri, 28 May 2010 09:51:10 -0400"
    # p time_in_zone.rfc822   # => "Fri, 28 May 2010 06:51:10 -0700"
    
    
    @current_user_zone = @time_in_zone
    starts_at = @current_user_zone.beginning_of_day
    ends_at = (@current_user_zone + 1.day).midnight
    @reservations = Reservation.weekly_reservations(@installation, starts_at, ends_at)
    
  end
  
  def list
    store_location
    @reservations = Reservation.list_reservations(@venue, params[:page])
    render :template => 'reservations/index'
  end

  def show
    store_location    
    @installation = @reservation.installation
    @venue = @reservation.venue
  end

  def new
    @reservation = Reservation.new
    @reservation.starts_at = params[:starts_at]
    @reservation.starts_at = @reservation.starts_at

    @reservation.ends_at = @reservation.starts_at + 1.hour
    @reservation.reminder_at = @reservation.starts_at - 2.days

    if @installation
      @reservation.installation_id = @installation.id
      @reservation.venue_id = @venue.id

      @reservation.fee_per_game = @installation.fee_per_game
      @reservation.fee_per_lighting = @installation.fee_per_lighting
    end

  end

  def create
    @reservation = Reservation.new(params[:reservation])  
    
    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end

    if @reservation.save    
      flash[:notice] = I18n.t(:successful_create)
      # redirect_to @reservation      
      redirect_to :action => 'list', :id => @venue
    else
      render :action => 'new'
    end
  end

  def update
    if @reservation.update_attributes(params[:reservation])  
      flash[:success] = I18n.t(:successful_update)
      redirect_to @reservation
    else
      render :action => 'edit'
    end
  end


  def set_reminder
    if @reservation.update_attribute("reminder", !@reservation.reminder)
      @reservation.update_attribute("reminder", @reservation.reminder)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  def set_public
    if @reservation.update_attribute("public", !@reservation.public)
      @reservation.update_attribute("public", @reservation.public)  

      flash[:success] = I18n.t(:successful_update)
      redirect_back_or_default('/index')
    else
      render :action => 'index'
    end
  end

  private
  def has_manager_access
    @venue = @reservation.venue
  
    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_reservation
    @reservation = Reservation.find(params[:id])
    @installation = @reservation.installation
    @venue = @reservation.venue
    
    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_installation
    @installation = Installation.find(params[:id])
    @venue = @installation.venue
    
    unless current_user.is_manager_of?(@venue)
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

