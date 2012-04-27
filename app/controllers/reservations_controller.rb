# require "base64"

class ReservationsController < ApplicationController
  before_filter :require_user

  before_filter   :get_installation,    :only => [:new, :index]
  before_filter   :get_reservation,     :only => [:show, :edit, :update, :destroy]
  before_filter   :has_manager_access,  :only => [:edit, :update, :destroy]


  def index  
    store_location
    @current_user_zone = Time.zone.now
    @time_frame = (@installation.timeframe).hour
    @minutes_to_reserve = 15.minutes

    @first_day = @current_user_zone
    last_day = @first_day + 7.days

    starts_at = convert_to_datetime_zone(@first_day, @installation.starts_at.utc)
    ends_at = convert_to_datetime_zone(last_day.midnight, @installation.ends_at.utc)

    @timetables = Timetable.installation_timetable(@installation)

    @reservations = Reservation.weekly_reservations(@installation, starts_at, ends_at)   
    @schedules = Schedule.weekly_reservations(@venue.marker, @installation, starts_at, ends_at) 
    @holidays = Holiday.holiday_week_day(@venue, starts_at, ends_at) 
    @venue_min_max_timetable = Timetable.venue_min_max_timetable(@venue)
    render @the_template  
  end

  def convert_to_datetime_zone(the_date, the_time)
    the_datetime = "#{the_date.strftime('%Y%m%d')} #{I18n.l(the_time, :format => :simple_time_zone_at)} "
    return DateTime.strptime(the_datetime, '%Y%m%d %H:%M %z')
  end

  def convert_to_datetime(the_date, the_time)
    the_datetime = "#{the_date.strftime('%Y%m%d')} #{I18n.l(the_time, :format => :simple_time_at)} "
    return DateTime.strptime(the_datetime, '%Y%m%d %H:%M')
  end

  def list
    store_location
    @reservations = Reservation.list_reservations(@venue, params[:page])
    set_the_template('reservations/index')
    render @the_template  
  end

  def show
    store_location    
    @installation = @reservation.installation
    @venue = @reservation.venue
    render @the_template  
  end

  def new
    block_token = Base64::decode64(params[:block_token].to_s).to_i
    time_frame = (@installation.timeframe).hour

    @reservation = Reservation.new    
    @reservation.name = "#{current_user.name}"   
    @reservation.starts_at = Time.zone.at(block_token)
    @reservation.ends_at = @reservation.starts_at + time_frame 
    @reservation.reminder_at = @reservation.starts_at - 2.days    
    @reservation.block_token = Base64::encode64(@reservation.starts_at.to_i.to_s)   
    # @reservation.description =  params[:block_token]

    # verify reservation has not already been made
    reservation_available = Reservation.reservation_available(@venue, @installation, @reservation)

    unless reservation_available      
      flash[:notice] = I18n.t(:reservations_unavailable)
      redirect_to :action => 'index', :id => @installation
      return
    end    

    if @installation
      @reservation.installation_id = @installation.id
      @reservation.venue_id = @venue.id

      @reservation.fee_per_pista = @installation.fee_per_pista
      @reservation.fee_per_lighting = @installation.fee_per_lighting
    end
    render @the_template  
  end

  def create  
    @reservation = Reservation.new(params[:reservation]) 
    @installation = @reservation.installation
    @venue = @installation.venue

    @reservation.code = "#{rand(36**8).to_s(36)}#{rand(36**8).to_s(36)}".strip[0..10].upcase

    block_token = Base64::decode64(@reservation.block_token.to_s).to_i
    time_frame = (@installation.timeframe).hour

    @reservation.name = current_user.name
    @reservation.item = current_user   

    @reservation.starts_at = Time.zone.at(block_token)
    @reservation.starts_at = @reservation.starts_at.change(:offset => "+0000")
    @reservation.ends_at = @reservation.starts_at + time_frame 
    @reservation.reminder_at = @reservation.starts_at - 2.days

    # verify reservation has not already been made
    if @reservation.starts_at.nil? or @reservation.ends_at.nil?
    else
      reservation_available = Reservation.reservation_available(@venue, @installation, @reservation)
    end

    unless reservation_available 
      flash[:notice] = I18n.t(:reservations_unavailable)
      redirect_to :action => 'index', :id => @installation
      return
    end

    if @installation
      @reservation.installation_id = @installation.id
      @reservation.venue_id = @venue.id

      @reservation.fee_per_pista = @installation.fee_per_pista
      @reservation.fee_per_lighting = @installation.fee_per_lighting
    end

    if @reservation.save    
      successful_create
      redirect_to :action => 'index', :id => @installation
    else
      render :action => 'new'
    end
  end

  def edit
    set_the_template('reservations/new')
    render @the_template
  end

  def update
    if @reservation.update_attributes(params[:reservation])  
      controller_successful_update
      redirect_to @reservation
    else
      render :action => 'edit'
    end
  end

  private
  def has_manager_access
    @venue = @reservation.venue

    unless is_current_manager_of(@venue)
      warning_unauthorized
      redirect_back_or_default('/index')
      return
    end
  end

  def get_reservation
    @reservation = Reservation.find(params[:id])
    @installation = @reservation.installation
    @venue = @reservation.venue
  end

  def get_installation
    @installation = Installation.find(params[:id])
    @venue = @installation.venue
  end

  def get_venue
    @venue = Venue.find(params[:id])
  end

end

