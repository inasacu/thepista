require "base64"

class HolidaysController < ApplicationController  
  before_filter   :require_user
  
  before_filter   :get_venue,             :only => [:set_holiday_open, :set_holiday_closed, :set_holiday_none]
  # before_filter   :is_venue_manager,      :only => [:set_holiday_open, :set_holiday_closed, :set_holiday_none]

  def index
    redirect_to root_url
  end

  def set_holiday_open    
    @holiday = @the_holiday if @the_holiday
    @holiday.holiday_hour = true
    @holiday.archive = false
    @holiday.save

    redirect_back_or_default('/index')  
  end

  def set_holiday_closed    
    @holiday = @the_holiday if @the_holiday
    @holiday.holiday_hour = false
    @holiday.archive = false
    @holiday.save

    redirect_back_or_default('/index')  
  end

  def set_holiday_none    
    @holiday = @the_holiday if @the_holiday
    @holiday.holiday_hour = true
    @holiday.archive = true
    @holiday.save

    redirect_back_or_default('/index')  
  end

  def create  
    @holiday = Holiday.new(params[:holiday]) 
    @venue = Venue.find(@holiday.venue)

    if @holiday.save    
      successful_create
      redirect_to @venue
    else
      redirect_to :index
    end
  end

  private
  def get_venue
    @venue = Venue.find(params[:venue_id])
    @block_token = Base64::decode64(params[:block_token].to_s).to_i
    @type = Type.default_holiday_type

    @holiday = Holiday.new 
    @holiday.venue = @venue
    @holiday.type = @type
    @holiday.starts_at = Time.zone.at(@block_token)
    @holiday.ends_at = Time.zone.at(@block_token)
    @holiday.starts_at = @holiday.starts_at.change(:hour => 0, :min => 0, :sec => 0)
    @holiday.ends_at  = @holiday.ends_at.change(:hour => 23, :min => 59, :sec => 59)

    @the_holiday = Holiday.holiday_available(@venue, @holiday)
  end  
  
  def is_venue_manager
    unless is_current_manager_of(@venue)
      warning_unauthorized
      redirect_back_or_default('/index')  
      return
    end
  end

end
