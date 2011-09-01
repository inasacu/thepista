class HolidaysController < ApplicationController
  before_filter :require_user

  before_filter   :get_venue,         :only => [:new, :create]
  before_filter   :get_holiday,       :only => [:edit, :update]

  def index  
    store_location
    @venues = Holiday.current_venues(@venue, params[:page])
  end

  def show
    redirect_to show_venue_url(:id => @venue)
  end

  def new
    @holiday = Timetable.new
    @holiday.venue = @venue
    @holiday.starts_at = @venue.starts_at
    @holiday.ends_at = @venue.ends_at
    @holiday.timeframe = @venue.timeframe

    @previous_holiday = Timetable.find(:first, :conditions => ["id = (select max(id) from holidays where venue_id = ?) ", @venue])    
    unless @previous_holiday.nil?     
      @holiday.type_id = @previous_holiday.type_id
      @holiday.starts_at = @previous_holiday.starts_at
      @holiday.ends_at = @previous_holiday.ends_at
      @holiday.timeframe = @previous_holiday.timeframe
    end

  end

  def create
    @holiday = Timetable.new(params[:holiday])  

    if @holiday.save 
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @venue
    else
      render :action => 'new'
    end
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

  def get_holiday
    @holiday = Timetable.find(params[:id]) if params[:id]
    @venue = @holiday.venue
    @venue = @venue.venue

    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

  def get_venue
    @venue = Holiday.find(params[:id]) if params[:id]
    @venue = Holiday.find(params[:holiday][:venue_id]) if params[:holiday]
    @venue = @venue.venue

    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')
      return
    end
  end

end

