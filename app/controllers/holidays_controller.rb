class HolidaysController < ApplicationController  
  before_filter :require_user

  def index
    redirect_to root_url
  end

  def create  
    @holiday = Holiday.new(params[:holiday]) 
    @venue = Venue.find(@holiday.venue)

    unless current_user.is_manager_of?(@venue)
      flash[:warning] = I18n.t(:unauthorized)
      redirect_back_or_default('/index')  
      return
    end

    if @holiday.save    
      flash[:notice] = I18n.t(:successful_create)
      redirect_to @venue
    else
      redirect_to :index
    end
  end

end