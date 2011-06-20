require 'active_support'  # needs rubygems
require "base64"

class ReservationsController < ApplicationController
  before_filter :require_user

  before_filter   :get_installation,    :only => [:new, :index]
  # before_filter   :get_venue,           :only => [:list]
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
		
    @reservations = Reservation.weekly_reservations(@installation, starts_at, ends_at)   
    @schedules = Schedule.weekly_reservations(@venue.marker, @installation, starts_at, ends_at) 
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
    render :template => 'reservations/index'
  end

  def show
    store_location    
    @installation = @reservation.installation
    @venue = @reservation.venue
  end

  def new
    block_token = Base64::decode64(params[:block_token].to_s).to_i
    time_frame = (@installation.timeframe).hour
    
    @reservation = Reservation.new    
    @reservation.concept = "#{@venue.name}"    
    @reservation.starts_at = Time.zone.at(block_token)
    @reservation.ends_at = @reservation.starts_at + time_frame 
    @reservation.reminder_at = @reservation.starts_at - 2.days    
    @reservation.block_token = Base64::b64encode(@reservation.starts_at.to_i.to_s)   
    # @reservation.description =  params[:block_token]
    
    # verify reservation has not already been made
    reservation_available = Reservation.find(:first, :conditions =>["starts_at = ? and ends_at = ? and 
                        item_id is not null and item_type is not null", @reservation.starts_at, @reservation.ends_at]).nil?
    
    unless reservation_available      
        flash[:notice] = I18n.t(:reservations_unavailable)
        redirect_to :action => 'index', :id => @installation
      return
    end    
    
    if @installation
      @reservation.installation_id = @installation.id
      @reservation.venue_id = @venue.id

      @reservation.fee_per_game = @installation.fee_per_game
      @reservation.fee_per_lighting = @installation.fee_per_lighting
    end
    
  end

  def create  
    @reservation = Reservation.new(params[:reservation]) 
    @installation = @reservation.installation
    @venue = @installation.venue
    
    # verify reservation has not already been made
    reservation_available = Reservation.find(:first, :conditions =>["starts_at = ? and ends_at = ? and 
                        item_id is not null and item_type is not null", @reservation.starts_at, @reservation.ends_at]).nil?
    
    unless reservation_available      
        flash[:notice] = I18n.t(:reservations_unavailable)
        redirect_to :action => 'index', :id => @installation
      return
    end

    if @installation
      @reservation.installation_id = @installation.id
      @reservation.venue_id = @venue.id

      @reservation.fee_per_game = @installation.fee_per_game
      @reservation.fee_per_lighting = @installation.fee_per_lighting
    end

    block_token = Base64::decode64(@reservation.block_token.to_s).to_i
    time_frame = (@installation.timeframe).hour

    @reservation.item = current_user   
     
    @reservation.starts_at = Time.zone.at(block_token)
    @reservation.starts_at = @reservation.starts_at.change(:offset => "+0000")
    @reservation.ends_at = @reservation.starts_at + time_frame 
    @reservation.reminder_at = @reservation.starts_at - 2.days    

    # unless current_user.is_manager_of?(@venue)
    #   flash[:warning] = I18n.t(:unauthorized)
    #   redirect_back_or_default('/index')
    #   return
    # end

    if @reservation.save    
      flash[:notice] = I18n.t(:successful_create)
      redirect_to :action => 'index', :id => @installation
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
    
    # unless current_user.is_manager_of?(@venue)
    #   flash[:warning] = I18n.t(:unauthorized)
    #   redirect_back_or_default('/index')
    #   return
    # end
  end

  def get_installation
    @installation = Installation.find(params[:id])
    @venue = @installation.venue
    
    # unless current_user.is_manager_of?(@venue)
    #   flash[:warning] = I18n.t(:unauthorized)
    #   redirect_back_or_default('/index')
    #   return
    # end
  end

  def get_venue
    @venue = Venue.find(params[:id])

    # unless current_user.is_manager_of?(@venue)
    #   flash[:warning] = I18n.t(:unauthorized)
    #   redirect_back_or_default('/index')
    #   return
    # end
  end

end
